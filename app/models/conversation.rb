class Conversation < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :contact
  
  validates :conversation_date, presence: true
  
  def display
    Myp.display_date_short(conversation_date, User.current_user)
  end

  after_save { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.conversation_date = Date.today
    result
  end
end
