module AllowExistingConcern extend ActiveSupport::Concern
  module ClassMethods
    protected
    
      # `name` must be a symbol that matches the symbol used in the call to
      # `accepts_nested_attributes_for`. The second parameter is the model
      # to search for the existing object. It may be `nil`, in which case
      # the model is assumed to be the same as `name`, capitalized.
      #
      # For more on why we must do this, see
      # http://stackoverflow.com/a/12064875/4135310
      def allow_existing(name, model = nil)
        define_method("#{name.to_s}_attributes=") do |attributes|
          if !attributes['id'].blank?
            
            # Remove all other attributes since we're searching for a
            # particular object and not creating a new one.
            attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
            
            Myp.set_existing_object(self, name, model, attributes['id'].to_i)
          end
          super(attributes)
        end
      end
      
      def allow_existing_children(name, children)
        define_method("#{name.to_s}_attributes=") do |attributes|
          attrs_to_delete = Array.new
          self.send("#{name.to_s}").each do |x|
            attributes.each do |key, value|
              children.each do |child|
                child_name = child[:name].to_s
                child_attributes = value["#{child_name}_attributes"]
                if value["_destroy"] != "1" && !child_attributes.blank?
                  idobj = child_attributes["id"]
                  if !idobj.blank?
                    child_value = x.send(child_name)
                    id = idobj.to_i
                    if !child_value.nil? && child_value.id == id
                      child_obj = Myp.set_existing_object(x, child_name, child[:model], id)
                      child_attributes.delete_if {|innerkey, innervalue| innerkey == "id" }
                      
                      # Calling super(attributes) re-loads this item we loaded
                      # above with the set_existing_object call, and doesn't
                      # update attributes (security feature), so we explicitly
                      # update them here. However, we also have to delete
                      # these attributes later so that the objects aren't
                      # overwritten. We still have to call
                      # `super(attributes)` because a new item may have been
                      # item at the same time an existing item was updated
                      
                      child_obj.assign_attributes(child_attributes)
                      attrs_to_delete.push(key)
                    end
                  end
                end
              end
            end
          end
          attributes.delete_if {|innerkey, innervalue| !attrs_to_delete.find_index{|atd| atd == innerkey}.nil? }
          super(attributes)
        end
      end
  end
end
