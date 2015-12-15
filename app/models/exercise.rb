class Exercise < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :exercise_start, presence: true
  
  def display
    Myp.display_datetime(exercise_start, User.current_user)
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.exercise_start = DateTime.now
    result
  end

  after_save { |record| DueItem.due_exercises(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_exercises(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
