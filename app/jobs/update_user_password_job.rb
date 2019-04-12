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

        ApplicationRecord.transaction do
          user.identities.each do |identity|
            MyplaceonlineExecutionContext.do_full_context(user, identity) do
              failed = []
              begin
                count = 0
                EncryptedValue.where(user: user).each do |encrypted_value|
                  begin
                    decrypted = Myp.decrypt(encrypted_value, old_password)
                    Myp.encrypt_value(user, decrypted, new_password, encrypted_value)
                    encrypted_value.save!
                  rescue => e1
                    failed << e1
                  end
                  count = count + 1
                end
                if failed.length > 0
                  raise Myp::ExceptionList.new(failed)
                end
                Rails.logger.debug{"UpdateUserPasswordJob updated #{count} encrypted values"}
              rescue => e2
                # TODO If there's an exception, then we need to undo the password
                # change and notify the user
                Rails.logger.debug{"UpdateUserPasswordJob failed #{failed.length}"}
                self.throw_with_contexts(e2)
              end
            end
          end
        end
        Rails.logger.debug{"Finished UpdateUserPasswordJob"}
      end
    end
  end
end
