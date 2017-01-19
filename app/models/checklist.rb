class Checklist < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :checklist_name, presence: true
  
  def display
    checklist_name
  end

  child_properties(name: :checklist_items)

  def all_checklist_items
    ChecklistItem.where(
      checklist_id: id
    ).order(["checklist_items.position ASC"])
  end

  child_properties(name: :checklist_references, foreign_key: "checklist_parent_id")

  def pre_checklist_references
    checklist_references.to_a.delete_if{|cr| !cr.pre_checklist }
  end
  
  def post_checklist_references
    checklist_references.to_a.delete_if{|cr| cr.pre_checklist }
  end
end
