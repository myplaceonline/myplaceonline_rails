class Doctor < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  DOCTOR_TYPES = [
    ["myplaceonline.doctors.type_primary_care", 0],
    ["myplaceonline.doctors.type_dentist", 1]
  ]

  validates :contact, presence: true
  
  def display
    result = contact.display
    if !doctor_type.nil?
      result = Myp.appendstrwrap(result, Myp.get_select_name(doctor_type, Doctor::DOCTOR_TYPES))
    end
    result
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact
end
