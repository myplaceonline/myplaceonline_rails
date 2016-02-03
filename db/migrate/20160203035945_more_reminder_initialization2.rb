class MoreReminderInitialization2 < ActiveRecord::Migration
  def change
    Contact.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
