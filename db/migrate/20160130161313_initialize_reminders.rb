class InitializeReminders < ActiveRecord::Migration
  def change
    DentalInsurance.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_create
    end
    DentistVisit.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    VehicleService.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    Promotion.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    GunRegistration.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    ToDo.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    Stock.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    Event.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    Exercise.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    HealthInsurance.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_create
    end
    DoctorVisit.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
    IdentityDriversLicense.all.each do |x|
      User.current_user = x.identity.user
      x.on_after_save
    end
  end
end
