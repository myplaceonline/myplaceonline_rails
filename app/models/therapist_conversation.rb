class TherapistConversation < MyplaceonlineIdentityRecord
  belongs_to :therapist
  
  validates :conversation_date, presence: true
end
