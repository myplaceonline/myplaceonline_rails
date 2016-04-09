class UpdateHappyThingReminders < ActiveRecord::Migration
  def change
    HappyThing.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
