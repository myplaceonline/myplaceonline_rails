class Doctor < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  validates :contact, presence: true
  
  def display
    contact.display
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
