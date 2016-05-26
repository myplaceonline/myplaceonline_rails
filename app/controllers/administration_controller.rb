class AdministrationController < ApplicationController
  skip_authorization_check
  before_action :check_admin
  
  def index; end

  def send_email
    @admin_email = AdminEmail.new(
      email: Email.new(email_category: I18n.t("myplaceonline.administration.send_email.default_category"))
    )
    
    if request.post?
      @admin_email = AdminEmail.new(
        params.require(:admin_email).permit(
          :send_only_to,
          :exclude_emails,
          email_attributes: EmailsController.param_names
        )
      )

      # There are no contacts or groups, so it must be a draft
      @admin_email.email.draft = true

      if @admin_email.save
        AdminSendEmailJob.perform_later(@admin_email)
        redirect_to administration_path,
          :flash => { :notice => I18n.t("myplaceonline.administration.send_email.sent") }
      end
    end
  end
  
  def gc
    GC.start
    sleep(5.0)
    redirect_to administration_path,
          :flash => { :notice => I18n.t("myplaceonline.administration.gc_collected") }
  end

  def check_admin
    Myp.ensure_encryption_key(session)
    if current_user.nil? || !current_user.admin?
      raise CanCan::AccessDenied.new("Not authorized")
    end
  end
end
