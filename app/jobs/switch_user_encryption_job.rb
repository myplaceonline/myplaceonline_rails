class SwitchUserEncryptionJob < ApplicationJob
  def perform(*args)
    
    ExecutionContext.push do
      
      job_context = args.shift
      import_job_context(job_context)
      
      Chewy.strategy(:atomic) do
        Rails.logger.info{"SwitchUserEncryptionJob started"}
        
        user = args[0]
        password = args[1]
        identity = user.current_identity

        Rails.logger.info{"SwitchUserEncryptionJob user=#{user.inspect}, identity=#{identity.inspect}"}
        
        MyplaceonlineExecutionContext.do_semifull_context(user) do
          MyplaceonlineExecutionContext.persistent_user_store = InMemoryPersistentUserStore.new
          MyplaceonlineExecutionContext.persistent_user_store[:password] = password

          model_mappings = {
            bank_account: [:account_number, :routing_number, :pin],
            credit_card: [:number, :expires, :security_code, :pin],
            diary_entry: [:entry],
            dream: [:dream],
            password: [:password],
            password_secret: [:answer],
            ssh_key: [:ssh_private_key]
          }
          model_mappings.each do |model_name, fields|
            model = model_name.to_s.camelize.constantize
            first_field = fields[0]
            model.where(:identity_id => identity.id, "#{first_field}_encrypted_id".to_sym => nil).each do |decrypted|
              Rails.logger.info{"SwitchUserEncryptionJob encrypting #{model_name} #{decrypted.id}"}
              decrypted.encrypt = true
              decrypted.save!
            end
          end
        end
        
        user.pending_encryption_switch = false
        user.save!

        Rails.logger.info{"SwitchUserEncryptionJob finished"}
      end
    end
  end
end
