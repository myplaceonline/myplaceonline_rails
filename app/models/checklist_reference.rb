class ChecklistReference < ActiveRecord::Base
  belongs_to :owner, class: Identity
  belongs_to :checklist_parent, class_name: Checklist
  belongs_to :checklist
  accepts_nested_attributes_for :checklist, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def checklist_attributes=(attributes)
    if !attributes['id'].blank?
      self.checklist = Checklist.find(attributes['id'])
    end
    super
  end
end
