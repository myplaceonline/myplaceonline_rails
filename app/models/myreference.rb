class Myreference < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  REFERENCE_TYPES = [
    ["myplaceonline.myreferences.type_personal", 0],
    ["myplaceonline.myreferences.type_professional", 1],
    ["myplaceonline.myreferences.type_educational", 2]
  ]

  validates :contact, presence: true
  
  def display
    contact.display
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact
end
