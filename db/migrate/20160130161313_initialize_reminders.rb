class InitializeReminders < ActiveRecord::Migration
  def change
    DentalInsurance.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_create
    end
    VehicleService.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
