class Specialist < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  SPECIALIST_TYPES = [
    ["myplaceonline.specialists.type_ultrasound", 0],
    ["myplaceonline.specialists.type_dermatologist", 1],
    ["myplaceonline.specialists.type_cosmetologist", 2]
  ]

  validates :contact, presence: true
  
  def display
    result = contact.display
    if !specialist_type.nil?
      result = Myp.appendstrwrap(result, Myp.get_select_name(specialist_type, Specialist::SPECIALIST_TYPES))
    end
    result
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact
end
