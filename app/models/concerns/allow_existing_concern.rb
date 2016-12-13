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
            
            Myp.set_existing_object(self, name, model, attributes['id'].to_i, action: :show)
          end
          super(attributes)
        end
      end
      
      def allow_existing_children(name, children)
        define_method("#{name.to_s}_attributes=") do |attributes|
          
          Rails.logger.debug{"allow_existing_children attributes #{attributes}"}
          
          attrs_to_delete = Array.new
          
          self.send("#{name.to_s}").each do |x|
            
            Rails.logger.debug{"allow_existing_children for name #{name} on #{children} on #{x.inspect}"}
            
            attributes.each do |key, value|
              
              Rails.logger.debug{"allow_existing_children   attribute #{key} = #{value}"}
              
              children.each do |child|
                
                child_name = child[:name].to_s
                child_attributes = value["#{child_name}_attributes"]
                
                Rails.logger.debug{"allow_existing_children     child #{child_name} = #{child_attributes}"}
                
                if value["_destroy"] != "1" && !child_attributes.blank?
                  
                  idobj = child_attributes["id"]
                  
                  Rails.logger.debug{"allow_existing_children       idobj = #{idobj}"}
                  
                  if !idobj.blank?
                    
                    child_value = x.send(child_name)
                    id = idobj.to_i
                    
                    Rails.logger.debug{"allow_existing_children         child_value = #{child_value.inspect} for #{id}"}
                    
                    if !child_value.nil? && child_value.id == id
                      
                      # Might need to apply properties to the intermediate object
                      intermediateProps = value.dup.delete_if {|innerkey, innervalue| innerkey == "id" || !children.index{|item| innerkey == "#{item[:name]}_attributes"}.nil? }

                      Rails.logger.debug{"allow_existing_children intermediate props to update #{intermediateProps}"}
                      
                      x.assign_attributes(intermediateProps)

                      child_obj = Myp.set_existing_object(x, child_name, child[:model], id)
                      
                      Rails.logger.debug{"allow_existing_children           child_obj = #{child_obj.inspect}"}
                      
                      child_attributes.delete_if {|innerkey, innervalue| innerkey == "id" }
                      
                      # Calling super(attributes) re-loads this item we loaded
                      # above with the set_existing_object call, and doesn't
                      # update attributes (security feature), so we explicitly
                      # update them here. However, we also have to delete
                      # these attributes later so that the objects aren't
                      # overwritten. We still have to call
                      # `super(attributes)` because a new item may have been
                      # added at the same time an existing item was updated.
                      # We might leave some old entries in with no changes, but
                      # that's fine since they're reloaded anyway
                      
                      child_obj.assign_attributes(child_attributes)
                      attrs_to_delete.push(key)
                    end
                  end
                end
              end
            end
            
            Rails.logger.debug{"allow_existing_children finished iteration"}
            
          end
          
          Rails.logger.debug{"allow_existing_children finished, now deleting #{attrs_to_delete}"}
          
          attributes.delete_if {|innerkey, innervalue| !attrs_to_delete.find_index{|atd| atd == innerkey}.nil? }

          Rails.logger.debug{"allow_existing_children final attributes #{attributes}"}
          
          super(attributes)
        end
      end
  end
end
