class Permission < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  ACTION_TYPES = [
    ["myplaceonline.permissions.action_manage", 0],
    ["myplaceonline.permissions.action_read", 1],
    ["myplaceonline.permissions.action_create", 2],
    ["myplaceonline.permissions.action_update", 3],
    ["myplaceonline.permissions.action_destroy", 4]
  ]
  
  validates :user, presence: true
  validates :action, presence: true
  validates :subject_class, presence: true
  
  def display
    result = user.display
    result = Myp.appendstrwrap(result, Myp.get_select_name(action, Permission::ACTION_TYPES))
    result = Myp.appendstrwrap(result, subject_class)
    if !subject_id.nil?
      result = Myp.appendstrwrap(result, subject_id.to_s)
    end
    result
  end
  
  belongs_to :user
  accepts_nested_attributes_for :user, reject_if: :all_blank
  allow_existing :user

  validate do
    if !subject_id.nil? && Myp.find_existing_object(subject_class.gsub(" ", "").singularize, subject_id).nil?
      errors.add(:subject_id, I18n.t("myplaceonline.permissions.invalid_id"))
    end
  end
end
