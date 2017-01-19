class UpdateUserPasswordJob < ApplicationJob
  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.debug{"Started UpdateUserPasswordJob"}
      user = args[0]
      old_password = args[1]
      new_password = args[2]
      MyplaceonlineExecutionContext.do_user(user) do
        ApplicationRecord.transaction do
          EncryptedValue.where(user: user).each do |encrypted_value|
            decrypted = Myp.decrypt(encrypted_value, old_password)
            Myp.encrypt_value(user, decrypted, new_password, encrypted_value)
            encrypted_value.save!
          end
        end
      end
      Rails.logger.debug{"Finished UpdateUserPasswordJob"}
    end
  end
end
