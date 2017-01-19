class Conversation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  CALENDAR_ITEM_CONTEXT_CONVERSATION = "conversation"
  
  belongs_to :contact
  
  validates :conversation_date, presence: true
  
  def display
    Myp.appendstrwrap(Myp.display_date_short_year(conversation_date, User.current_user), Myp.ellipses_if_needed(self.conversation, 64))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.conversation_date = Date.today
    result
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      contact.on_after_save
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    contact.on_after_destroy
  end

  def final_search_result
    contact
  end
end
