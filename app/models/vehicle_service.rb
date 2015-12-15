class VehicleService < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :vehicle
  validates :short_description, presence: true

  after_save { |record| DueItem.due_vehicles(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_vehicles(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
