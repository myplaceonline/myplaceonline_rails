class Conversation < MyplaceonlineIdentityRecord
  belongs_to :contact
  
  validates :conversation_date, presence: true

  after_save { |record| DueItem.due_contacts(User.current_user) }
  after_destroy { |record| DueItem.due_contacts(User.current_user) }
end
