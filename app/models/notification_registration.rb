class NotificationRegistration < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  belongs_to :user
end
