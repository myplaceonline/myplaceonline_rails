class Doctor < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DOCTOR_TYPES = [
    ["myplaceonline.doctors.type_primary_care", 0],
    ["myplaceonline.doctors.type_dentist", 1],
    ["myplaceonline.doctors.type_ultrasound", 2],
    ["myplaceonline.doctors.type_dermatologist", 3],
    ["myplaceonline.doctors.type_cosmetologist", 4],
    ["myplaceonline.doctors.type_physical_therapy", 5],
    ["myplaceonline.doctors.type_endocrinologist", 6]
  ]

  def display
    result = contact.display
    if !doctor_type.nil?
      result = Myp.appendstrwrap(result, Myp.get_select_name(doctor_type, Doctor::DOCTOR_TYPES))
    end
    result
  end
  
  child_property(name: :contact, required: true)
end
