class SubscribeController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index
    
    @backurl = params[:backurl]
    if @backurl.blank?
      if !request.referer.nil?
        @backurl = URI(request.referer).path
      else
        @backurl = root_path
      end
    end
    
    @email = params[:email]
    if !@email.blank?
      if !(@email =~ Devise.email_regexp).nil?
        domain = Myp.website_domain
        if !domain.mailing_list.nil?
          if !domain.mailing_list.has_email?(@email)
            MyplaceonlineExecutionContext.do_full_context(domain.identity.user, domain.identity) do
              GroupContact.create!(
                group: domain.mailing_list,
                contact: Contact.new(
                  contact_identity: Identity.new(
                    name: @email,
                    identity_emails: [
                      IdentityEmail.new(
                        email: @email,
                      )
                    ]
                  )
                )
              )
            end
            flash.clear
            @content = t("myplaceonline.subscribe.successfully_subscribed")
          else
            flash.clear
            @content = t("myplaceonline.subscribe.already_subscribed")
          end
        else
          flash[:error] = t("myplaceonline.subscribe.mailing_list_not_configured")
        end
      else
        flash[:error] = t("myplaceonline.general.invalid_email")
      end
    elsif request.post?
      flash[:error] = t("myplaceonline.subscribe.email_not_specified")
    end
  end
end
