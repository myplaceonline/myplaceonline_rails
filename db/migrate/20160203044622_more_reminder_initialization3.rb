class MoreReminderInitialization3 < ActiveRecord::Migration
  def change
    ApartmentTrashPickup.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
