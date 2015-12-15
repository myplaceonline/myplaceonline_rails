class Conversation < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :contact
  
  validates :conversation_date, presence: true

  after_save { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
