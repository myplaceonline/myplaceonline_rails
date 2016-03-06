class PermissionShare < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  validates :email, presence: true
  validates :subject_class, presence: true
  validates :subject_id, presence: true

  has_many :permission_share_children, :dependent => :destroy
  
  belongs_to :email
  accepts_nested_attributes_for :email, reject_if: :all_blank

  def display
    subject_class + "/" + subject_id.to_s
  end
  
  belongs_to :share
  
  def link
    mainlink = "/" + subject_class.underscore.pluralize + "/" + subject_id.to_s
    clazz = Object.const_get(subject_class)
    if clazz.respond_to?("has_shared_page?") && clazz.has_shared_page?
      mainlink += "/shared"
    end
    Myp.root_url + mainlink + "?token=" + share.token
  end
  
  def get_obj
    Object.const_get(subject_class).find_by(id: subject_id)
  end
  
  def has_obj
    !subject_class.nil?
  end
  
  def simple_path
    "/" + subject_class.underscore.pluralize + "/" + subject_id.to_s
  end
  
  def async?
    clazz = Object.const_get(subject_class)
    clazz.respond_to?("share_async?") && clazz.share_async?(self)
  end
  
  def execute_share
    clazz = Object.const_get(subject_class)
    clazz.execute_share(self)
  end
  
  def send_email(target_obj = nil)
    url = link
    obj = get_obj
    prefix = obj.display
    cat = Myp.instance_to_category(obj)
    tcat = I18n.t("myplaceonline.category.#{cat.name}").singularize
    email.send_email(
      "<p>#{tcat}: " + ActionController::Base.helpers.link_to(prefix, url) + "</p>",
      tcat + ": " + prefix + "\n\n" + url,
      target_obj,
      self
    )
  end
  
  def child_selections_list
    if !child_selections.blank?
      child_selections.split(",").map{|x| x.to_i}
    else
      []
    end
  end
end
