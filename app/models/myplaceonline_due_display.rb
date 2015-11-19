class MyplaceonlineDueDisplay < MyplaceonlineIdentityRecord
  after_save { |record| DueItem.recalculate_due(User.current_user) }
  after_destroy { |record| DueItem.recalculate_due(User.current_user) }
end
