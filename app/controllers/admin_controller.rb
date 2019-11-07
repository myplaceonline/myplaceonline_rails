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
  
  def crontab
    Rails.logger.info{"AdminController.crontab"}
    Myp.crontab
    render(json: { success: true })
  end
  
  def create_test_job
    ApplicationJob.perform(TestJob, "hello world", "test")
    respond_to do |format|
      format.json { render(json: { success: true }) }
      format.html { redirect_to(admin_path, notice: "Test job created") }
    end
  end

  def create_test_error_job
    ApplicationJob.perform(TestErrorJob)
    respond_to do |format|
      format.json { render(json: { success: true }) }
      format.html { redirect_to(admin_path, notice: "Test error job created") }
    end
  end

  def execute_command
    Rails.logger.info{"AdminController execute_command #{params[:command]}"}
    if request.post?
      @command = params[:command]
      ApplicationJob.perform(AdminExecuteCommandJob, @command)
    end
  end

  def index; end

  def send_email
    Rails.logger.info{"AdminController send_email"}
    
    @admin_email = AdminEmail.new(
      email: Email.new(
               email_category: I18n.t("myplaceonline.admin.send_email.default_category", host: Myp.website_domain.display),
               subject: I18n.t("myplaceonline.admin.send_email.default_category", host: Myp.website_domain.display) + ": "
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
    Rails.logger.info{"AdminController send_text_message"}
    
    @admin_text_message = AdminTextMessage.new(
      text_message: TextMessage.new(
               message_category: I18n.t("myplaceonline.admin.send_text_message.default_category", host: Myp.website_domain.display)
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
  
  def send_direct_email
    Rails.logger.info{"AdminController send_direct_email"}
    
    @from = params[:from]
    @to = params[:to]
    @cc = params[:cc]
    @bcc = params[:bcc]
    @subject = params[:subject]
    @body = params[:body]
    
    if @from.blank?
      @from = Myp.create_email
    end
    
    if !@body.blank?
      if !@from.blank?
        if !@to.blank?
          if !@subject.blank?
            content = Myp.markdown_to_html(@body)
            content_plain = @body
            
            Myp.send_email(
              @to.split(","),
              @subject,
              content.html_safe,
              @cc.split(","),
              @bcc.split(","),
              content_plain
            )
            
            redirect_to(
              admin_path,
              flash: { notice: I18n.t("myplaceonline.admin.send_direct_email.sent") }
            )
          else
            flash[:error] = I18n.t("myplaceonline.admin.send_direct_email.subject_missing")
          end
        else
          flash[:error] = I18n.t("myplaceonline.admin.send_direct_email.to_missing")
        end
      else
        flash[:error] = I18n.t("myplaceonline.admin.send_direct_email.from_missing")
      end
    end
  end
  
  def send_direct_text_message
    Rails.logger.info{"AdminController send_direct_text_message"}
    
    @to = params[:to]
    @body = params[:body]
    
    if !@body.blank?
      if !@to.blank?
        
        @to.split(",").each do |to|
          Myp.send_sms(to: to, body: @body)
        end
        
        redirect_to(
          admin_path,
          flash: { notice: I18n.t("myplaceonline.admin.send_direct_text_message.sent") }
        )
      else
        flash[:error] = I18n.t("myplaceonline.admin.send_direct_text_message.to_missing")
      end
    end
  end
  
  def gc
    Rails.logger.info{"AdminController gc"}
    
    GC.start
    sleep(5.0)
    redirect_to admin_path,
          :flash => { :notice => I18n.t("myplaceonline.admin.gc_collected") }
  end
  
  def reinitialize
    Rails.logger.info{"AdminController reinitialize"}
    
    Myp.reinitialize
    render(json: { success: true })
  end
end
