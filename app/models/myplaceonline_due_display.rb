class MyplaceonlineDueDisplay < MyplaceonlineIdentityRecord
  include TimespanConcern
  
  timespan_field :exercise_threshold
  timespan_field :contact_best_friend_threshold
  
  after_save { |record| DueItem.recalculate_due(User.current_user) }
  after_destroy { |record| DueItem.recalculate_due(User.current_user) }
end
