class InfoController < ApplicationController
  skip_before_filter :do_authenticate_user
  skip_authorization_check
  
  def index; end
  def credits; end
  def diagnostics; end
  def faq; end
  def serverinfo; end

  def sleep_time
    if !current_user.nil? && current_user.admin?
      duration = params[:duration]
      if duration.blank?
        duration = 1
      else
        duration = duration.to_f
      end
      sleep(duration)
    end
    redirect_to info_diagnostics_path
  end

  def raise_server_exception
    if !current_user.nil? && current_user.admin?
      raise "Fake Server Exception"
    end
    redirect_to info_diagnostics_path
  end
  
  def contact
    @obj = SiteContact.new
    if !params[:subject].blank?
      @obj.subject = params[:subject]
    end
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
