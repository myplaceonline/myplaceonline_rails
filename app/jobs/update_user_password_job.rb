class UpdateUserPasswordJob < ApplicationJob
  def do_perform(*args)
    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        user = args[0]
        old_password = args[1]
        new_password = args[2]

        Rails.logger.debug{"Started UpdateUserPasswordJob old_password: #{old_password}, new_password: #{new_password} user: #{user.id}"}

        count = 0
        ActiveRecord::Base.transaction(requires_new: true) do
          map = {}
          user.identities.each do |identity|
            MyplaceonlineExecutionContext.do_full_context(user, identity) do
              begin
                EncryptedValue.where(user: user).order(:id).each do |encrypted_value|
                  #Rails.logger.debug{"UpdateUserPasswordJob map size = #{map.size}"}
                  if !map.has_key?(encrypted_value.id)
                    Rails.logger.debug{"UpdateUserPasswordJob started processing #{encrypted_value}"}
                    decrypted = Myp.decrypt(encrypted_value, old_password)
                    Myp.encrypt_value(user, decrypted, new_password, encrypted_value)
                    encrypted_value.save!
                    count = count + 1
                    Rails.logger.debug{"UpdateUserPasswordJob finished processing #{encrypted_value}"}
                    map[encrypted_value.id] = 1
                  #else
                    #Rails.logger.debug{"UpdateUserPasswordJob skipping #{encrypted_value}"}
                  end
                end
              rescue => e
                # TODO If there's an exception, then we need to undo the password
                # change and notify the user
                Rails.logger.debug{"UpdateUserPasswordJob failed #{e} : #{e.backtrace.join("\n")}"}
                self.throw_with_contexts(e)
              end
            end
          end
        end
        
        Rails.logger.debug{"UpdateUserPasswordJob updated #{count} encrypted values"}
        
        user.send_email("Encrypted values successfully updated", "Your password change has led to #{count} encrypted values successfully being encrypted with your new password. You may now access items such as passwords.")
        
        Rails.logger.debug{"Finished UpdateUserPasswordJob"}
      end
    end
  end
end
