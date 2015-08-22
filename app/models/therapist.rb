class Therapist < MyplaceonlineActiveRecord

  validates :name, presence: true

  def display
    name
  end
  
  has_many :therapist_conversations, :dependent => :destroy
  accepts_nested_attributes_for :therapist_conversations, allow_destroy: true, reject_if: :all_blank
  
  def all_conversations
    TherapistConversation.where(therapist_id: id).order(["therapist_conversations.conversation_date DESC"])
  end
  
  has_many :therapist_emails, :dependent => :destroy
  accepts_nested_attributes_for :therapist_emails, allow_destroy: true, reject_if: :all_blank
  
  has_many :therapist_phones, :dependent => :destroy
  accepts_nested_attributes_for :therapist_phones, allow_destroy: true, reject_if: :all_blank
  
  has_many :therapist_locations, :dependent => :destroy
  accepts_nested_attributes_for :therapist_locations, allow_destroy: true, reject_if: :all_blank
end
