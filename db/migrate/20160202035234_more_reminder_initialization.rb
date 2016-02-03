class MoreReminderInitialization < ActiveRecord::Migration
  def change
    Identity.all.each do |x|
      if !x.contact.nil?
        User.current_user = x.contact.identity.user
        x.on_after_save
      end
    end
  end
end
