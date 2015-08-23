class ChecklistReference < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  belongs_to :checklist_parent, class_name: Checklist
  belongs_to :checklist
  accepts_nested_attributes_for :checklist, allow_destroy: true, reject_if: :all_blank
  allow_existing :checklist
end
