# By default, Rails has some protection against form submissions loading arbitrary objects from the database into the
# object tree (e.g. http://stackoverflow.com/a/12064875/4135310). This makes sense, because anyone could just craft
# any ID they want to add as a child object. These methods allow a model to override this behavior by overriding the
# *_attributes= methods. We process the attributes passed in, safely load up any existing objects from the database,
# check the authorization for this user, and then modify the attributes map which we pass to super() so that Rails then
# makes any changes to the loaded objects based on the form submission.
module AllowExistingConcern extend ActiveSupport::Concern
  
  UPDATE_TYPE_UNKNOWN = 0
  UPDATE_TYPE_COMBINE = 1
  
  class_methods do
    PREVIOUS_OBJECT_BLANK = 0
    PREVIOUS_OBJECT_DIFFERENT = 1
    PREVIOUS_OBJECT_SAME = 2
    
    def allow_existing(name:)
      define_method("#{name.to_s}_attributes=") do |attributes|

        Rails.logger.debug{"allow_existing setting attributes for name: #{name}, attributes: #{attributes}, self: #{self.inspect}"}
        
        self.set_property_with_attributes(name: name, attributes: attributes)

        Rails.logger.debug{"allow_existing final attributes: #{attributes}"}

        super(attributes)
      end
    end
    
    def allow_existing_children(name)
      define_method("#{name.to_s}_attributes=") do |attributes|
        
        Rails.logger.debug{"allow_existing_children name: #{name}"}
        
        self.set_properties_with_attributes(name: name, attributes: attributes)
        
        Rails.logger.debug{"allow_existing_children before setting:"}
        self.send("#{name.to_s}").each do |updated_child|
          Rails.logger.debug{"allow_existing_children old child: #{Myp.debug_print(updated_child)}"}
        end
        
        super(attributes)

        Rails.logger.debug{"allow_existing_children after setting:"}
        self.send("#{name.to_s}").each do |updated_child|
          Rails.logger.debug{"allow_existing_children updated child: #{Myp.debug_print(updated_child)}"}
        end
      end
    end
  end
  
  included do
    def set_property_with_attributes(name:, attributes:, update_type: AllowExistingConcern::UPDATE_TYPE_UNKNOWN)
      model = self.class.child_property_models[name]
      
      Rails.logger.debug{"set_property_with_attributes name: #{name}, model: #{model}, attributes: #{Myp.debug_print(attributes)}, self: #{self.inspect}"}
      
      if !attributes.nil?
        if !attributes["id"].blank?
          if !attributes["_updatetype"].blank?
            update_type = attributes["_updatetype"].to_i
            attributes.delete_if {|innerkey, innervalue| innerkey == "_updatetype" }
          end
          
          previous_object_id = self.send(name.to_s + "_id")
          if !previous_object_id.nil?
            previous_object_id = previous_object_id.to_s
          end
          
          Rails.logger.debug{"set_property_with_attributes previous_object_id: #{previous_object_id}, update_type: #{update_type}"}
          
          previous_object = PREVIOUS_OBJECT_BLANK
          if !previous_object_id.blank?
            previous_object = PREVIOUS_OBJECT_DIFFERENT
            if attributes["id"] == previous_object_id
              previous_object = PREVIOUS_OBJECT_SAME
            end
          end
          
          # Let's first check whether the non-id attributes are set or not
          check_attributes = attributes.dup
          check_attributes.delete_if {|innerkey, innervalue| innerkey == "id" }

          non_id_attributes_set = false
          if !model.attributes_blank?(attributes: check_attributes)
            non_id_attributes_set = true
          end
          
          Rails.logger.debug{"set_property_with_attributes object: #{attributes["id"]}, previous: #{previous_object_id}, previous_object: #{previous_object}, non_id_attributes_set: #{non_id_attributes_set}"}
          
          case update_type
          when AllowExistingConcern::UPDATE_TYPE_UNKNOWN
            # If non-id attributes are set, then we pretty much just discard whether or not the existing item is
            # set and create a new item
            if non_id_attributes_set
              attributes.delete_if {|innerkey, innervalue| innerkey == "id" }
              Rails.logger.debug{"set_property_with_attributes creating new obj with attributes #{Myp.debug_print(attributes)}"}
              newobj = Myp.new_model(model)
              newobj.assign_attributes(attributes)
              Rails.logger.debug{"set_property_with_attributes creating new obj #{Myp.debug_print(newobj)}"}
              self.send("#{name}=", newobj)
              attributes.clear
            else
              attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
              # Let's go find the existing object, authorize it, and set the property on this object
              existing_obj = Myp.set_existing_object(self, name, model, attributes["id"].to_i, action: :show)
              Rails.logger.debug{"set_property_with_attributes existing_obj: #{Myp.debug_print(existing_obj)}"}
            end
          when AllowExistingConcern::UPDATE_TYPE_COMBINE
            existing_obj = Myp.set_existing_object(self, name, model, attributes["id"].to_i, action: :show)

            attributes.delete_if {|innerkey, innervalue| innerkey == "id" }
            existing_obj.assign_attributes(attributes)
            attributes.clear

            Rails.logger.debug{"set_property_with_attributes combined existing_obj: #{Myp.debug_print(existing_obj)}"}
          end
          
          Rails.logger.debug{"set_property_with_attributes final attributes: #{attributes}"}
        else
          attributes.delete_if {|innerkey, innervalue| innerkey == "_updatetype" }
        end
      end
    end

    def set_properties_with_attributes(name:, attributes:)
      Rails.logger.debug{"set_properties_with_attributes setting attributes for name: #{name}, on self: #{self.inspect}, attributes: #{Myp.debug_print(attributes)}"}
      
      model = MyplaceonlineActiveRecordBaseConcern.get_attributes_model_mapping(klass: self.class, name: name)
      
      Rails.logger.debug{"set_properties_with_attributes model: #{model}"}
      
      attrs_to_delete = []
      
      Rails.logger.debug{"set_properties_with_attributes before processing:"}
      self.send("#{name.to_s}").each do |updated_child|
        Rails.logger.debug{"set_properties_with_attributes initial child: #{Myp.debug_print(updated_child)}"}
      end
      
      # Go through the existing collection of items to see if we should update any of them
      self.send("#{name.to_s}").each do |x|
        
        Rails.logger.debug{"set_properties_with_attributes for name #{name} on #{x.inspect}"}
        
        attributes.each do |key, value|
          if value["_destroy"] != "1" && !value["id"].blank? && value["id"].to_i == x.id
            Rails.logger.debug{"set_properties_with_attributes found matching attributes: #{Myp.debug_print(value)}"}
            
            x.class.child_property_models.each do |child, model|
              child_attributes = value["#{child}_attributes"]
              if !child_attributes.nil?
                if child_attributes.keys.all?{|key| key.integer? }
                  x.set_properties_with_attributes(name: child, attributes: child_attributes)
                else
                  x.set_property_with_attributes(name: child, attributes: child_attributes)
                end
              end
            end
            
            value.delete_if{|key, value| key == "id" || key.end_with?("attributes")}
            
            Rails.logger.debug{"set_properties_with_attributes assigning remaining attributes: #{Myp.debug_print(value)}"}
            
            x.assign_attributes(value)
            
            # Delete this key from the attributes we pass to super because we've already updated this child,
            # and we don't want super to munge this updates, only to add any new ones
            attrs_to_delete << key
          end
        end
      end

      attributes.delete_if {|innerkey, innervalue| !attrs_to_delete.find_index{|atd| atd == innerkey}.nil? }
      
      Rails.logger.debug{"set_properties_with_attributes final attributes #{attributes}"}
    end
  end
end
