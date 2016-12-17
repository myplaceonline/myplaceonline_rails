class AdminController < ApplicationController

  # We will authorize, if needed, in the check_authorization call
  skip_before_action :do_authenticate_user
  
  # No resources here so nothing to authorize. The authorization is in check_authorization to check admin or trusted IP
  skip_authorization_check

  before_action :check_authorization
  
  def check_authorization
    Rails.logger.info{"AdminController check_authorization IP: #{request.remote_ip}"}
    
    if Rails.env.production? && !Myp.trusted_client_ips.index(request.remote_ip).nil?
      # Production crontab requests from a trusted IP doesn't need authentication nor authorization
    else
      do_authenticate_user
      check_password
      if !current_user.admin?
        raise CanCan::AccessDenied.new("Not authorized")
      end
    end
  end
  
  def ensure_pending_all_users
    CalendarItemReminder.ensure_pending_all_users
    render(json: { success: true })
  end
  
  def create_test_job
    ApplicationJob.perform(TestJob, "hello world", "test")
    respond_to do |format|
      format.json { render(json: { success: true }) }
      format.html { redirect_to(admin_path, notice: "Test job created") }
    end
  end

  def index; end

  def send_email
    @admin_email = AdminEmail.new(
      email: Email.new(
               email_category: I18n.t("myplaceonline.admin.send_email.default_category"),
               subject: I18n.t("myplaceonline.admin.send_email.default_category") + ": "
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
        ApplicationJob.perform(AdminSendEmailJob, @admin_email)
        redirect_to admin_path,
          :flash => { :notice => I18n.t("myplaceonline.admin.send_email.sent") }
      end
    end
  end
  
  def send_text_message
    @admin_text_message = AdminTextMessage.new(
      text_message: TextMessage.new(
               message_category: I18n.t("myplaceonline.admin.send_text_message.default_category")
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
        ApplicationJob.perform(AdminSendTextMessageJob, @admin_text_message)
        redirect_to admin_path,
          :flash => { :notice => I18n.t("myplaceonline.admin.send_text_message.sent") }
      end
    end
  end
  
  def gc
    GC.start
    sleep(5.0)
    redirect_to admin_path,
          :flash => { :notice => I18n.t("myplaceonline.admin.gc_collected") }
  end
end
