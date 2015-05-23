class Checklist < ActiveRecord::Base
  belongs_to :identity
  validates :checklist_name, presence: true
  
  before_create :do_before_save
  before_update :do_before_save
  
  def display
    checklist_name
  end

  has_many :checklist_items, :dependent => :destroy
  accepts_nested_attributes_for :checklist_items, allow_destroy: true, reject_if: :all_blank

  def all_checklist_items
    ChecklistItem.where(
      checklist_id: id
    ).order(["checklist_items.position ASC"])
  end

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
