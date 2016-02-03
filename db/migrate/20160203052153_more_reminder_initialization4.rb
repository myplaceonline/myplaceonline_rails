class MoreReminderInitialization4 < ActiveRecord::Migration
  def change
    PeriodicPayment.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
