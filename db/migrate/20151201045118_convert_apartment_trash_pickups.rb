class ConvertApartmentTrashPickups < ActiveRecord::Migration
  def change
    add_reference :apartment_trash_pickups, :reminder, index: true
    ApartmentTrashPickup.all.each do |atp|
      User.current_user = atp.owner.owner
      r = Reminder.new
      r.start_date = atp.start_date
      r.period_type = atp.period_type
      r.period = atp.period
      r.owner = atp.owner
      r.save!
      atp.reminder = r
      atp.save!
    end
  end
end
