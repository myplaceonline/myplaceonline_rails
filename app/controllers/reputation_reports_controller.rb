class ReputationReportsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.report_status_s
  end

  def footer_items_show
    result = super
    if @obj.allow_admin? && User.current_user.admin?
      result << {
        title: I18n.t("myplaceonline.reputation_reports.contact_reporter"),
        link: reputation_report_contact_reporter_path(@obj),
        icon: "phone"
      }
      result << {
        title: I18n.t("myplaceonline.reputation_reports.propose_price"),
        link: reputation_report_propose_price_path(@obj),
        icon: "action"
      }
    end
    result
  end
  
  def contact_reporter
    set_obj
    
    @subject = params[:subject]
    @message = params[:message]
    
    if request.post?
      
      @obj.identity.send_message(@message, @message, @subject, reply_to: User.current_user.email, bcc: User.current_user.email)
      
      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.reputation_reports.reporter_contacted") }
      )
    end
  end
  
  def propose_price
    set_obj
    
    @price = params[:price]
    @message = params[:message]
    
    if request.post?
      
      subject = I18n.t(
        "myplaceonline.reputation_reports.propose_price_subject",
        type: Myp.get_select_name(@obj.report_type, ReputationReport::REPORT_TYPES),
        name: @obj.agent.display,
      )
      
      #link = new_trip_trip_story_path(@obj)
      link = root_url
      
      message = I18n.t(
        "myplaceonline.reputation_reports.propose_price_body",
        name: @obj.agent.display,
        cost: @price,
        details: @message,
        link: link,
      )
      
      @obj.identity.send_message(message, message, subject, reply_to: User.current_user.email, bcc: User.current_user.email)
      @obj.report_status = ReputationReport::REPORT_STATUS_PENDING_PAYMENT_FROM_USER
      @obj.save!
      
      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.reputation_reports.reporter_contacted") }
      )
    end
  end

  protected
    def deny_guest
      if current_user.guest?
        raise Myp::SuddenRedirectError.new(new_registration_path(User.new), I18n.t("myplaceonline.users.please_sign_up"))
      end
    end

    def obj_params
      params.require(:reputation_report).permit(
        :short_description,
        :report_type,
        :story,
        :notes,
        reputation_report_files_attributes: FilesController.multi_param_names,
        agent_attributes: Agent.param_names,
      )
    end

    def admin_sees_all?
      true
    end
end
