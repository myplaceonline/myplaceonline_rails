class Conversation < MyplaceonlineActiveRecord
  belongs_to :contact
  
  validates :conversation_date, presence: true
end
