class ApartmentTrashPickup < MyplaceonlineIdentityRecord
  TRASH_TYPES = [
    ["myplaceonline.trash.type_general", 0],
    ["myplaceonline.trash.type_recycling", 1]
  ]
  
  belongs_to :apartment

  validates :trash_type, presence: true
  validates :start_date, presence: true
  validates :period_type, presence: true
  validates :period, presence: true
end
