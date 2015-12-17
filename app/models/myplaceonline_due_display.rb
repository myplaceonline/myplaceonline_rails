class MyplaceonlineDueDisplay < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include TimespanConcern
  
  timespan_field :exercise_threshold
  timespan_field :contact_best_friend_threshold
  timespan_field :contact_good_friend_threshold
  timespan_field :contact_acquaintance_threshold
  timespan_field :contact_best_family_threshold
  timespan_field :contact_good_family_threshold
  timespan_field :dentist_visit_threshold
  timespan_field :doctor_visit_threshold
  timespan_field :status_threshold
  timespan_field :trash_pickup_threshold
  timespan_field :periodic_payment_before_threshold
  timespan_field :periodic_payment_after_threshold
  timespan_field :drivers_license_expiration_threshold
  timespan_field :birthday_threshold
  timespan_field :promotion_threshold
  timespan_field :gun_registration_expiration_threshold
  timespan_field :event_threshold
  timespan_field :stocks_vest_threshold
  timespan_field :todo_threshold
  
  after_save { |record| DueItem.recalculate_due(User.current_user) }
  
  # We don't want to recalculate due items on a delete because there's no
  # context.
  # after_destroy { |record| DueItem.recalculate_due(User.current_user) }
end
