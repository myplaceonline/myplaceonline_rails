module ModelHelpersConcern extend ActiveSupport::Concern
  module ClassMethods
    protected
    
      def boolean_time_transfer(boolean_field_name, time_field_name)
        define_method("#{boolean_field_name}=") do |newvalue|
          if newvalue == "1"
            self.send("#{time_field_name}=", Time.now)
          else
            self.send("#{time_field_name}=", nil)
          end
        end
        
        define_method("#{boolean_field_name}") do
          self.send(time_field_name).nil? ? "0" : "1"
        end
      end

  end
end
