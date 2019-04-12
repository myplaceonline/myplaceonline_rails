class UpdateUserPasswordJob < ApplicationJob
  def do_perform(*args)
    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.debug{"Started UpdateUserPasswordJob"}
        user = args[0]
        old_password = args[1]
        new_password = args[2]

        Rails.logger.debug{"Started UpdateUserPasswordJob old_password: #{old_password}, new_password: #{new_password}"}

        user.identities.each do |identity|
          MyplaceonlineExecutionContext.do_full_context(user, identity) do
            begin
              ApplicationRecord.transaction do
                EncryptedValue.where(user: user).each do |encrypted_value|
                  decrypted = Myp.decrypt(encrypted_value, old_password)
                  Myp.encrypt_value(user, decrypted, new_password, encrypted_value)
                  encrypted_value.save!
                end
              end
            rescue => e
              # If there's an exception, then we need to undo the password
              # change and notify the user
              self.throw_with_contexts(e)
            end
          end
        end
        Rails.logger.debug{"Finished UpdateUserPasswordJob"}
      end
    end
  end
end
