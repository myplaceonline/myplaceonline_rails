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
        # def name_attributes=(attributes)
        define_method("#{name.to_s}_attributes=") do |attributes|
          if !attributes['id'].blank?
            
            if model.nil?
              model = Object.const_get(name.to_s.capitalize)
            end
            
            # Remove all other attributes since we're searching for a
            # particular object and not creating a new one.
            attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
            
            id = attributes['id'].to_i
            obj = model.find_by(
              id: id,
              owner: User.current_user.primary_identity
            )
            if obj.nil?
              raise "Could not find " + model.to_s + " with ID " + id.to_s
            end
            self.send(
              "#{name.to_s}=",
              obj
            )
          end
          super(attributes)
        end
      end
  end
end
