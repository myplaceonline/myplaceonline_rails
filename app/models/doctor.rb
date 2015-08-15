class Doctor < ActiveRecord::Base
  include AllowExistingConcern

  DOCTOR_TYPES = [
    ["myplaceonline.doctors.type_primary_care", 0],
    ["myplaceonline.doctors.type_dentist", 1]
  ]

  belongs_to :owner, class_name: Identity
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

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
