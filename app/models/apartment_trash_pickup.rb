class ApartmentTrashPickup < MyplaceonlineIdentityRecord

  TRASH_TYPES = [
    ["myplaceonline.trash.type_general", 0],
    ["myplaceonline.trash.type_recycling", 1]
  ]
  
  belongs_to :apartment
  
  belongs_to :reminder
  accepts_nested_attributes_for :reminder, allow_destroy: true, reject_if: :all_blank
  validates_presence_of :reminder

  validates :trash_type, presence: true
  
  after_save { |record| DueItem.due_apartments(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_apartments(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
