class MoreReminderInitialization5 < ActiveRecord::Migration
  def change
    Membership.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
