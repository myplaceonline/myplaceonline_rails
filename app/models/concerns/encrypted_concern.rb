module EncryptedConcern extend ActiveSupport::Concern
  class_methods do
    def belongs_to_encrypted(name)

      if !respond_to?(:encrypt)
        define_method("encrypt") do
          if @encrypt.nil?
            @encrypt = send("#{name}_encrypted?")
          end
          result = @encrypt

          Rails.logger.debug{"EncryptedConcern encrypt check for #{self} = #{result}"}
          
          result
        end

        define_method("encrypt=") do |newvalue|
          Rails.logger.debug{"EncryptedConcern encrypt set for #{self} = #{newvalue}"}
          @encrypt = newvalue
        end
      end

      define_method("#{name}_encrypted?") do
        result = !send("#{name}_encrypted").nil?
        Rails.logger.debug{"EncryptedConcern encrypted? for #{self} = #{result}"}
        result
      end

      define_method(name) do
        if !send("#{name}_encrypted?")
          result = super()
          Rails.logger.debug{"EncryptedConcern '#{name}' check unencrypted for #{self} = #{result}"}
        else
          result = Myp.decrypt_with_user_password!(
            send("#{name}_encrypted")
          )
          Rails.logger.debug{"EncryptedConcern '#{name}' check encrypted for #{self} = #{result}"}
        end
        result
      end

      define_method("#{name}_finalize") do |encrypt = false|
        is_changed = self.send("#{name}_changed?")
        Rails.logger.debug{"EncryptedConcern '#{name}_finalize' called for #{self}, encrypt: #{encrypt}, changed: #{is_changed}, self.encrypt: #{self.encrypt}"}
        if is_changed || (self.send("#{name}_encrypted?") && !self.encrypt) || (!self.send("#{name}_encrypted?") && self.encrypt)
          do_encrypt = encrypt || self[:encrypt] == true || (self.respond_to?("encrypt") && (self.encrypt == "1" || self.encrypt == true))
          Rails.logger.debug{"EncryptedConcern #{name}_finalize do_encrypt: #{do_encrypt}"}
          if do_encrypt
            new_encrypted_value = Myp.encrypt_with_user_password!(
              User.current_user,
              self[name]
            )
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
              existing_encrypted_value = self.send("#{name}_encrypted")
              self.send("#{name}_encrypted=", nil)
              self.save!
              existing_encrypted_value.destroy!
            end
          end
        end
      end
    end
  end
end
