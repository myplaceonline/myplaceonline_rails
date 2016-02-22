class PermissionShare < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  validates :subject, presence: true
  validates :subject_class, presence: true
  validates :subject_id, presence: true

  has_many :permission_share_contacts
  accepts_nested_attributes_for :permission_share_contacts, allow_destroy: true, reject_if: :all_blank
  
  validate :has_contacts
  
  def display
    id.to_s
  end
  
  def has_contacts
    if permission_share_contacts.length == 0
      errors.add(:contacts, I18n.t("myplaceonline.permissions.requires_contacts"))
    end
  end

  validate do
    if Myp.find_existing_object(subject_class, subject_id).nil?
      errors.add(:subject_id, I18n.t("myplaceonline.permissions.invalid_id"))
    end
  end
  
  belongs_to :share
  
  def link
    url_for("/" + subject_class.underscore.pluralize + "/" + subject_id.to_s + "?token=" + share.token)
  end
end
