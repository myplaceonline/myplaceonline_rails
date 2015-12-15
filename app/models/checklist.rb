class Checklist < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :checklist_name, presence: true
  
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

  has_many :checklist_references, :foreign_key => 'checklist_parent_id'
  accepts_nested_attributes_for :checklist_references, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :checklist_references, [{:name => :checklist}]

  def pre_checklist_references
    checklist_references.to_a.delete_if{|cr| !cr.pre_checklist }
  end
  
  def post_checklist_references
    checklist_references.to_a.delete_if{|cr| cr.pre_checklist }
  end
end
