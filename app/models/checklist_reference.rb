class ChecklistReference < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :checklist_parent, class_name: "Checklist"
  
  child_property(name: :checklist)

  def self.skip_check_attributes
    ["pre_checklist"]
  end
end
