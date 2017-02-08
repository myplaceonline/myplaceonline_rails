class SwitchUserEncryption < ActiveRecord::Migration[5.0]
  def change
    ExecutionContext.stack do
      User.all.each do |user|
        User.current_user = user
        if !user.encrypt_by_default
          user.encrypt_by_default = true
          user.pending_encryption_switch = true
          user.save!
          puts "Switched for user #{user.email}"
        end
      end
    end
  end
end
