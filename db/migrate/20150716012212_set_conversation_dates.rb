class SetConversationDates < ActiveRecord::Migration
  def change
    Conversation.all.each do |c|
      if c.conversation_date.nil?
        c.conversation_date = c.created_at
        c.save!
      end
    end
  end
end
