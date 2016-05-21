class AdministrationController < ApplicationController
  skip_authorization_check
  before_action :check_admin
  
  def index; end

  def send_email
    @email = Email.new(email_category: I18n.t("myplaceonline.administration.send_email.default_category"))
    
    if request.post?
      @email = Email.new(
        params.require(:email).permit(
          EmailsController.param_names
        )
      )

      # There are no contacts or groups, so it must be a draft
      @email.draft = true

      if @email.save
        AdminSendEmailJob.perform_later(@email)
        redirect_to administration_path,
          :flash => { :notice => I18n.t("myplaceonline.administration.send_email.sent") }
      end
    end
  end

  def check_admin
    Myp.ensure_encryption_key(session)
    if current_user.nil? || !current_user.admin?
      raise CanCan::AccessDenied.new("Not authorized")
    end
  end
end
