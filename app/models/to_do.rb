class ToDo < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :short_description, presence: true
  
  def display
    short_description
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.due_time = DateTime.now
    result
  end
  
  after_save { |record| DueItem.due_todos(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_todos(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
