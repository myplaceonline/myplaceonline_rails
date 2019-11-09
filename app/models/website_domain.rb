class WebsiteDomain < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  AJAX_CONFIG_ENABLE_ALWAYS = 0
  AJAX_CONFIG_DISABLE_UNAUTHENTICATED = 1
  AJAX_CONFIG_DISABLE_ALWAYS = 2

  AJAX_CONFIGS = [
    ["myplaceonline.website_domains.ajax_configs.enable_always", AJAX_CONFIG_ENABLE_ALWAYS],
    ["myplaceonline.website_domains.ajax_configs.disable_always", AJAX_CONFIG_DISABLE_ALWAYS],
    ["myplaceonline.website_domains.ajax_configs.disable_unauthenticated", AJAX_CONFIG_DISABLE_UNAUTHENTICATED],
  ]

  validates :domain_name, presence: true

  child_property(name: :website, required: true)

  child_property(name: :domain_host, model: Membership)
  
  child_properties(name: :website_domain_ssh_keys)

  child_properties(name: :website_domain_registrations)
  
  child_property(name: :favicon_png_identity_file, model: IdentityFile)

  child_property(name: :favicon_ico_identity_file, model: IdentityFile)

  child_property(name: :default_header_icon_identity_file, model: IdentityFile)

  child_properties(name: :website_domain_myplets, sort: "position ASC")

  child_properties(name: :website_domain_properties, sort: "property_key ASC")

  child_property(name: :mailing_list, model: Group)
  
  def display
    domain_name
  end

  validate do
    if !self.homepage_path.blank? && !self.authorize_homepage_path
      errors.add(:homepage_path, I18n.t("myplaceonline.website_domains.homepage_path_not_authorized"))
    end
  end
  
  def homepage_path_object_action
    result = nil
    if !self.homepage_path.blank?
      pieces = self.homepage_path.split("/")
      if pieces.length < 2
        raise "Unexpected path"
      end
      last_piece = pieces[pieces.length - 1]
      if Myp.is_number?(last_piece)
        action = :show
        id = last_piece.to_i
        controller_name = pieces[pieces.length - 2]
      else
        action = pieces[pieces.length - 1].to_sym
        id = pieces[pieces.length - 2].to_i
        controller_name = pieces[pieces.length - 3]
      end
      result = [Object.const_get(controller_name.camelize.singularize).send("find", id), action]
    end
    result
  end
  
  def authorize_homepage_path
    obj_action = self.homepage_path_object_action
    if !obj_action[0].nil?
      Ability.authorize(identity: User.current_user.current_identity, subject: obj_action[0], action: obj_action[1])
    else
      false
    end
  end
  
  def main_domain
    result = hosts
    i = result.index(",")
    if !i.nil?
      result = result[0..i-1]
    end
    result
  end
  
  def processed_static_homepage
    html = self.static_homepage
    
    if !html.blank?
      if Myp::EXTRA_DEBUG
        Rails.logger.debug{"Myp.reinitialize_in_rails_context preparing static homepage #{html}"}
      end
      
      html = Myp.prepare_website_domain_html(html: html)
    end
    
    #Rails.logger.debug{"Homepage for #{website_domain.display}:\n#{html}"}
    
    html
  end

  after_commit :on_after_update, on: [:update]
  
  def on_after_update
    if self.verified && Rails.env.development?
      Myp.reinitialize
    end
  end
  
  def welcome_message_blank?
    self.new_user_welcome.blank?
  end
  
  def welcome_message
    self.new_user_welcome.blank? ? I18n.t("myplaceonline.default_domain.category_welcome") : self.new_user_welcome
  end
end
