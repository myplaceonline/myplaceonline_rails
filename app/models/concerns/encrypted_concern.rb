module EncryptedConcern extend ActiveSupport::Concern
  module ClassMethods
    protected
      def belongs_to_encrypted(name)
        define_method("#{name}_encrypted?") do
          !send("#{name}_encrypted").nil?
        end
        
        define_method(name) do
          if !send("#{name}_encrypted?")
            #logger.debug{"Getting non-encrypted value for #{name}"}
            result = super()
          else
            #logger.debug{"Getting encrypted value for #{name}"}
            result = Myp.decrypt_from_session(
              ApplicationController.current_session,
              send("#{name}_encrypted")
            )
          end
          #logger.debug{"result: #{result}"}
          result
        end
        
        define_method("#{name}_finalize") do |encrypt = false|
          do_encrypt = encrypt || self[:encrypt] || (self.respond_to?("encrypt") && self.encrypt == "1")
          if do_encrypt
            new_encrypted_value = Myp.encrypt_from_session(
              User.current_user,
              ApplicationController.current_session,
              self[name]
            )
            #logger.debug{"decrypted: #{Myp.decrypt_from_session(ApplicationController.current_session, new_encrypted_value)}"}
            #logger.debug{"new_encrypted_value: #{new_encrypted_value.inspect}"}
            self.send("#{name}=", nil)
            if send("#{name}_encrypted?")
              Myp.copy_encrypted_value_attributes(
                new_encrypted_value,
                self.send("#{name}_encrypted")
              )
            else
              self.send("#{name}_encrypted=", new_encrypted_value)
            end
          else
            if send("#{name}_encrypted?")
              self.send("#{name}_encrypted").destroy!
              self.send("#{name}_encrypted=", nil)
            end
          end
        end
      end
  end
end
