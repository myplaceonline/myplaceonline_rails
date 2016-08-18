class Conversation < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  CALENDAR_ITEM_CONTEXT_CONVERSATION = "conversation"
  
  belongs_to :contact
  
  validates :conversation_date, presence: true
  
  def display
    Myp.display_date_short(conversation_date, User.current_user)
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.conversation_date = Date.today
    result
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    contact.on_after_save
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    contact.on_after_destroy
  end

  def final_search_result
    contact
  end
end
