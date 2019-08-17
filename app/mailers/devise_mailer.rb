# https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer
class DeviseMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  
  def confirmation_instructions(record, token, opts={})
    opts[:subject] = I18n.t("myplaceonline.mail.confirmation_subject", name: Myp.website_domain.domain_name)
    from_email = Myp.create_email(display: Myp.website_domain.domain_name)
    opts[:from] = from_email
    opts[:reply_to] = from_email
    super
  end
end
