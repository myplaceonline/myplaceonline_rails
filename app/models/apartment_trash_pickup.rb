class ApartmentTrashPickup < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  TRASH_TYPES = [
    ["myplaceonline.trash.type_general", 0],
    ["myplaceonline.trash.type_recycling", 1]
  ]
  
  belongs_to :apartment
  
  belongs_to :repeat
  accepts_nested_attributes_for :repeat, allow_destroy: true, reject_if: :all_blank
  validates_presence_of :repeat

  validates :trash_type, presence: true
end
