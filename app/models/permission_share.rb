class PermissionShare < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  validates :subject, presence: true
  validates :subject_class, presence: true
  validates :subject_id, presence: true

  has_many :permission_share_contacts, :dependent => :destroy
  accepts_nested_attributes_for :permission_share_contacts, allow_destroy: true, reject_if: :all_blank
  
  has_many :permission_share_children, :dependent => :destroy
  
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
    Rails.logger.debug{"Validating #{subject_class}:#{subject_id}"}
    if Myp.find_existing_object(subject_class, subject_id).nil?
      errors.add(:subject_id, I18n.t("myplaceonline.permissions.invalid_id"))
    end
  end
  
  belongs_to :share
  
  def link
    mainlink = "/" + subject_class.underscore.pluralize + "/" + subject_id.to_s
    clazz = Object.const_get(subject_class)
    if clazz.respond_to?("has_shared_page?") && clazz.has_shared_page?
      mainlink += "/shared"
    end
    url_for(mainlink + "?token=" + share.token)
  end
  
  def async?
    clazz = Object.const_get(subject_class)
    clazz.respond_to?("share_async?") && clazz.share_async?
  end
  
  def execute_async
    clazz = Object.const_get(subject_class)
    clazz.execute_async(self)
  end
  
  def send_email
    content = "<p>" + ERB::Util.html_escape_once(body) + "</p>\n\n"
    url = link
    content += "<p>" + ActionController::Base.helpers.link_to(url, url) + "</p>"
    
    cc = nil
    if copy_self
      cc = identity.user.email
    end
    to = Array.new
    permission_share_contacts.each do |permission_share_contact|
      permission_share_contact.contact.contact_identity.emails.each do |identity_email|
        to.push(identity_email)
      end
    end
    Myp.send_email(to, subject, content.html_safe, cc)
  end
end
