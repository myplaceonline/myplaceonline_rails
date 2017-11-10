class UpdateUserPasswordJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.stack do
      
      job_context = args.shift
      import_job_context(job_context)

      Chewy.strategy(:atomic) do
        Rails.logger.debug{"Started UpdateUserPasswordJob"}
        user = args[0]
        old_password = args[1]
        new_password = args[2]
        user.identities.each do |identity|
          MyplaceonlineExecutionContext.do_full_context(user, identity) do
            ApplicationRecord.transaction do
              EncryptedValue.where(user: user).each do |encrypted_value|
                decrypted = Myp.decrypt(encrypted_value, old_password)
                Myp.encrypt_value(user, decrypted, new_password, encrypted_value)
                encrypted_value.save!
              end
            end
          end
        end
        Rails.logger.debug{"Finished UpdateUserPasswordJob"}
      end
    end
    
  end
end
