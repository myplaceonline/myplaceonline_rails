class AdministrationController < ApplicationController
  skip_authorization_check
  before_action :check_admin
  
  def index; end

  def send_email
    @admin_email = AdminEmail.new(
      email: Email.new(
               email_category: I18n.t("myplaceonline.administration.send_email.default_category"),
               subject: I18n.t("myplaceonline.administration.send_email.default_category") + ": "
             )
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
  
  def send_text_message
    @admin_text_message = AdminTextMessage.new(
      text_message: TextMessage.new(
               message_category: I18n.t("myplaceonline.administration.send_text_message.default_category")
             )
    )
    
    if request.post?
      @admin_text_message = AdminTextMessage.new(
        params.require(:admin_text_message).permit(
          :send_only_to,
          :exclude_numbers,
          text_message_attributes: TextMessagesController.param_names
        )
      )

      # There are no contacts or groups, so it must be a draft
      @admin_text_message.text_message.draft = true

      if @admin_text_message.save
        AdminSendTextMessageJob.perform_later(@admin_text_message)
        redirect_to administration_path,
          :flash => { :notice => I18n.t("myplaceonline.administration.send_text_message.sent") }
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
    check_password
    if current_user.nil? || !current_user.admin?
      raise CanCan::AccessDenied.new("Not authorized")
    end
  end

  def check_password(level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    MyplaceonlineController.check_password(current_user, session, level: level)
  end
end
