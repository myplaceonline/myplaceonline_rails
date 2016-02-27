class InfoController < ApplicationController
  skip_before_filter :do_authenticate_user
  skip_authorization_check
  
  def index; end
  def credits; end
  def diagnostics; end
  def faq; end

  def contact
    @obj = SiteContact.new
    if request.post?
      @obj = SiteContact.new(
        params.require(:site_contact).permit(
          :name,
          :email,
          :subject,
          :body
        )
      )
      if @obj.save
        email_content = %{
Name: #{@obj.name}
Email: #{@obj.email}
Body:
#{@obj.body}
        }
        Myp.send_support_email_safe(@obj.subject, email_content)
        redirect_to "/",
          :flash => { :notice =>
                      I18n.t("myplaceonline.contact.sent")
                    }
      end
    end
  end
end
