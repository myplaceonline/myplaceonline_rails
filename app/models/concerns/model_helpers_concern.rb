module ModelHelpersConcern extend ActiveSupport::Concern
  class_methods do
    def boolean_time_transfer(boolean_field_name, time_field_name)
      define_method("#{boolean_field_name}=") do |newvalue|
        if newvalue == "1" || newvalue == true
          self.send("#{time_field_name}=", Time.now)
        else
          self.send("#{time_field_name}=", nil)
        end
      end
      
      define_method("#{boolean_field_name}") do
        self.send(time_field_name).nil? ? "0" : "1"
      end
      
      define_method("#{boolean_field_name}?") do
        self.send(time_field_name).nil? ? false : true
      end
    end
    
    def bit_flags_transfer(field_prefix, field_values, storage_field_name)
      field_values.each do |field_value|
        bit_value = field_value[1]
        define_method("#{field_prefix}#{bit_value}=") do |newvalue|
          curvalue = self.send("#{storage_field_name}")
          if curvalue.nil?
            curvalue = 0
          end
          if newvalue == "1"
            curvalue |= bit_value.to_i
            self.send("#{storage_field_name}=", curvalue)
          else
            curvalue &= ~(bit_value.to_i)
            self.send("#{storage_field_name}=", curvalue)
          end
        end
      
        define_method("#{field_prefix}#{bit_value}") do
          curvalue = self.send("#{storage_field_name}")
          if curvalue.nil?
            curvalue = 0
          end
          curvalue & bit_value != 0
        end
      end
    end
  end
end
