class RemoveSpecialists < ActiveRecord::Migration
  def change
    Specialist.all.each do |specialist|
      User.current_user = specialist.identity.user
      doctor_type = 0
      Doctor.create(
        identity_id: specialist.identity_id,
        contact_id: specialist.contact_id,
        created_at: specialist.created_at,
        updated_at: specialist.updated_at,
        doctor_type: specialist.specialist_type + 2,
        visit_count: specialist.visit_count
      )
    end
    Specialist.destroy_all
  end
end
