class Therapist < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :contact, presence: true
  
  def display
    result = ""
    if !contact.nil?
      result = contact.display
    end
    result
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact

  has_many :therapist_conversations, :dependent => :destroy
  accepts_nested_attributes_for :therapist_conversations, allow_destroy: true, reject_if: :all_blank
  
  has_many :therapist_emails, :dependent => :destroy
  accepts_nested_attributes_for :therapist_emails, allow_destroy: true, reject_if: :all_blank
  
  has_many :therapist_phones, :dependent => :destroy
  accepts_nested_attributes_for :therapist_phones, allow_destroy: true, reject_if: :all_blank
  
  has_many :therapist_locations, :dependent => :destroy
  accepts_nested_attributes_for :therapist_locations, allow_destroy: true, reject_if: :all_blank
end
