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
    result = []
    
    invoice = @obj.get_site_invoice
    
    if @obj.allow_admin? && User.current_user.admin?
      
      @obj.ensure_agent_contact
      
      result << {
        title: I18n.t("myplaceonline.reputation_reports.contact_reporter"),
        link: reputation_report_contact_reporter_path(@obj),
        icon: "phone"
      }
      result << {
        title: I18n.t("myplaceonline.reputation_reports.contact_accused"),
        link: reputation_report_contact_accused_path(@obj),
        icon: "phone"
      }
      
      if invoice.nil?
        result << {
          title: I18n.t("myplaceonline.reputation_reports.propose_price"),
          link: reputation_report_propose_price_path(@obj),
          icon: "action"
        }
      else
        result << {
          title: I18n.t("myplaceonline.reputation_reports.invoice"),
          link: site_invoice_path(invoice),
          icon: "shop"
        }
      end
      
      if !@obj.report_status.nil? && @obj.report_status == ReputationReport::REPORT_STATUS_SITE_INVESTIGATING
        result << {
          title: I18n.t("myplaceonline.reputation_reports.initial_decision"),
          link: reputation_report_initial_decision_path(@obj),
          icon: "action"
        }
      end
      
      if !@obj.report_status.nil? && @obj.report_status == ReputationReport::REPORT_STATUS_PUBLISHED
        result << {
          title: I18n.t("myplaceonline.reputation_reports.unpublish"),
          link: reputation_report_unpublish_path(@obj),
          icon: "back"
        }
      end
      
      result << {
        title: I18n.t("myplaceonline.reputation_reports.add_message"),
        link: new_reputation_report_reputation_report_message_path(@obj),
        icon: "plus"
      }
      
      result << {
        title: I18n.t("myplaceonline.reputation_reports.messages"),
        link: reputation_report_reputation_report_messages_path(@obj),
        icon: "bars"
      }

#       result << {
#         title: I18n.t("myplaceonline.reputation_reports.ensure_agent_contact"),
#         link: reputation_report_ensure_agent_contact_path(@obj),
#         icon: "user"
#       }
      
      result << {
        title: I18n.t("myplaceonline.reputation_reports.update_status"),
        link: reputation_report_update_status_path(@obj),
        icon: "check"
      }
    end
    
    if @obj.current_user_owns?
      
      if @obj.waiting_for_payment?
        
        if !invoice.nil? && !invoice.paid?
          result << {
            title: I18n.t("myplaceonline.site_invoices.pay"),
            link: site_invoice_pay_path(invoice),
            icon: "shop"
          }
        end
      end
      
      result << {
        title: I18n.t("myplaceonline.reputation_reports.request_status"),
        link: reputation_report_request_status_path(@obj),
        icon: "info"
      }
      
      if !@obj.report_status.nil? && @obj.report_status == ReputationReport::REPORT_STATUS_PENDING_INITIAL_DECISION_REVIEW
        result << {
          title: I18n.t("myplaceonline.reputation_reports.review"),
          link: reputation_report_review_path(@obj),
          icon: "search"
        }
      end
      
      # Doesn't support read permissions on message attachments yet
#       if @obj.reputation_report_messages.count > 0
#         result << {
#           title: I18n.t("myplaceonline.reputation_reports.messages"),
#           link: reputation_report_reputation_report_messages_path(@obj),
#           icon: "bars"
#         }
#       end
    end
    
    if @obj.report_type == ReputationReport::REPORT_TYPE_SHAME && @obj.allow_mediation? && !@obj.report_status.nil? && @obj.report_status == ReputationReport::REPORT_STATUS_SITE_INVESTIGATING
      result << {
        title: I18n.t("myplaceonline.reputation_reports.mediation"),
        link: reputation_report_mediation_path(@obj),
        icon: "comment"
      }
    end
    
    result + super
  end
  
  def contact_reporter
    set_obj
    deny_nonadmin
    
    @subject = params[:subject]
    @message = params[:message]
    
    if request.post?
      
      @obj.send_reporter_message(subject: @subject, body_short_markdown: @message, body_long_markdown: @message)
      
      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.reputation_reports.reporter_contacted") }
      )
    end
  end
  
  def contact_accused
    set_obj
    deny_nonadmin
    
    @subject = params[:subject]
    @message = params[:message]
    
    if request.post?
      
      @obj.send_accused_message(subject: @subject, body_short_markdown: @message, body_long_markdown: @message)
      
      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.reputation_reports.accused_contacted") }
      )
    end
  end
  
  def propose_price
    set_obj
    deny_nonadmin
    
    @price = params[:price]
    @message = params[:message]
    
    if request.post?
      
      subject = I18n.t(
        "myplaceonline.reputation_reports.propose_price_subject",
        type: Myp.get_select_name(@obj.report_type, ReputationReport::REPORT_TYPES),
        name: @obj.agent.display,
      )
      
      first_charge = nil
      
      if @obj.report_type == ReputationReport::REPORT_TYPE_SHAME
        first_charge = @price.to_f * 0.5
      end
      
      site_invoice = SiteInvoice.create!(
        invoice_description: subject,
        invoice_time: User.current_user.time_now,
        invoice_amount: @price,
        invoice_status: SiteInvoice::INVOICE_STATUS_PENDING,
        model_class: model.name,
        model_id: @obj.id,
        identity_id: @obj.identity_id,
        first_charge: first_charge,
      )
      
      link = site_invoice_pay_url(site_invoice)
      
      if @obj.report_type == ReputationReport::REPORT_TYPE_SHAME
        message = I18n.t(
          "myplaceonline.reputation_reports.propose_price_body2",
          name: @obj.agent.display,
          cost: Myp.number_to_currency(@price),
          cost2: Myp.number_to_currency(first_charge),
          details: @message,
          link: link,
        )
      else
        message = I18n.t(
          "myplaceonline.reputation_reports.propose_price_body",
          name: @obj.agent.display,
          cost: Myp.number_to_currency(@price),
          details: @message,
          link: link,
        )
      end
      
      @obj.report_status = ReputationReport::REPORT_STATUS_PENDING_PAYMENT_FROM_USER
      @obj.save!
      
      @obj.send_reporter_message(subject: subject, body_short_markdown: message, body_long_markdown: message)

      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.reputation_reports.reporter_contacted") }
      )
    end
  end
  
  def request_status
    set_obj
    
    link = reputation_report_url(@obj)
    @obj.send_admin_message(subject: "Reputation Report Status Request", body_markdown: "[#{link}](#{link})")
    
    redirect_to(
      obj_path,
      flash: { notice: I18n.t("myplaceonline.reputation_reports.status_requested") }
    )
  end

  def update_status
    set_obj
    deny_nonadmin
    
    if request.post?
      @obj.report_status = params[:new_status]
      @obj.save!
      
      redirect_to_obj
    end
  end
  
  def initial_decision
    set_obj
    deny_nonadmin
    
    if request.post?
      
      approved = Myp.param_bool(params, :approved)
      @message = params[:message]
      
      @obj.report_status = ReputationReport::REPORT_STATUS_PENDING_INITIAL_DECISION_REVIEW
      @obj.save!
      
      link = reputation_report_review_url(@obj)
      subject = I18n.t(
        "myplaceonline.reputation_reports.initial_decision_subject",
        type: Myp.get_select_name(@obj.report_type, ReputationReport::REPORT_TYPES),
        name: @obj.agent.display,
      )
      message = I18n.t(
        approved ? "myplaceonline.reputation_reports.initial_decision_yes" : "myplaceonline.reputation_reports.initial_decision_no",
        type: Myp.get_select_name(@obj.report_type, ReputationReport::REPORT_TYPES),
        name: @obj.agent.display,
        link: link,
        details: @message,
      )
      
      @obj.send_reporter_message(
        subject: subject,
        body_short_markdown: message,
        body_long_markdown: message
      )
      
      redirect_to_obj
    end
  end
  
  def review
    set_obj
    
    if request.post?
      proposed_changes = params[:proposed_changes]
      if !proposed_changes.blank?
        link = reputation_report_url(@obj)
        @obj.send_admin_message(subject: "Reputation Report Proposed Changes", body_markdown: "Proposed Changes for [#{link}](#{link}):\n\n#{proposed_changes}")
        
        @obj.report_status = ReputationReport::REPORT_STATUS_SITE_INVESTIGATING
        @obj.save!
        
        redirect_to(obj_path, flash: { notice: I18n.t("myplaceonline.reputation_reports.proposed_changes_submitted") })
      else
        invoice = @obj.get_site_invoice
        if !invoice.nil? && !invoice.paid?
          @obj.report_status = ReputationReport::REPORT_STATUS_PENDING_FINAL_PAYMENT_FROM_USER
          @obj.save!
          
          redirect_to site_invoice_pay_path(invoice)
        else
          @obj.publish
          redirect_to(obj_path, flash: { notice: I18n.t("myplaceonline.reputation_reports.approved_message") })
        end
      end
    end
  end
  
  def unpublish
    set_obj
    
    @obj.unpublish
    redirect_to_obj
  end
  
  def show_share
    false
  end
  
  def show_favorites
    false
  end
  
  def show_additional
    false
  end
  
  def show_add
    false
  end
  
  def show_back_to_list
    !User.current_user.guest?
  end

  def show_favorite_button
    false
  end

  def show_archive_button
    false
  end
  
  def index_settings_link?
    false
  end
  
  def ensure_agent_contact
    set_obj
    deny_nonadmin
    
    @obj.ensure_agent_contact
    
    redirect_to_obj
  end
  
  def mediation
    set_obj
    
    if request.post?
      @comment = params[:comment]
      
      if !@comment.blank?
        
        if @obj.current_user_owns?
          type = "mediation_reporter"
        elsif User.current_user.admin?
          type = "mediator"
        else
          type = "mediation_accused"
        end
        
        @obj.mediation = "**#{I18n.t("myplaceonline.reputation_reports." + type)}** @ _#{User.current_user.time_now}_:\n\n#{@comment}<hr />\n\n#{@obj.mediation}"
        
        current_user_owns = @obj.current_user_owns?
        cu = MyplaceonlineExecutionContext.user
        admin_user = User.where(email: Myp.create_email(email_only: true)).take!
        admin_identity = admin_user.domain_identity
        
        MyplaceonlineExecutionContext.do_context(@obj) do
          @obj.save!

          private_link = reputation_report_mediation_url(@obj)
          public_link = @obj.public_mediation_link
          
          subject = I18n.t(
            "myplaceonline.reputation_reports.mediation_updated_subject",
          )
          
          body_long_markdown_private = I18n.t(
            "myplaceonline.reputation_reports.mediation_updated_body_long",
            type: I18n.t("myplaceonline.reputation_reports." + type),
            comment: @comment,
            link: private_link,
          )
          
          body_long_markdown_public = I18n.t(
            "myplaceonline.reputation_reports.mediation_updated_body_long",
            type: I18n.t("myplaceonline.reputation_reports." + type),
            comment: @comment,
            link: public_link,
          )
          
          body_short_markdown_private = I18n.t(
            "myplaceonline.reputation_reports.mediation_updated_body_short",
            link: private_link,
          )
          
          body_short_markdown_public = I18n.t(
            "myplaceonline.reputation_reports.mediation_updated_body_short",
            link: public_link,
          )
          
          MyplaceonlineExecutionContext.do_full_context(admin_user, admin_identity) do
            if cu.admin?
              @obj.send_reporter_message(
                subject: subject,
                body_short_markdown: body_short_markdown_private,
                body_long_markdown: body_long_markdown_private
              )
              @obj.send_accused_message(
                subject: subject,
                body_short_markdown: body_short_markdown_public,
                body_long_markdown: body_long_markdown_public
              )
            elsif current_user_owns
              @obj.send_admin_message(
                subject: subject,
                body_markdown: body_long_markdown_private,
              )
              @obj.send_accused_message(
                subject: subject,
                body_short_markdown: body_short_markdown_public,
                body_long_markdown: body_long_markdown_public
              )
            else
              @obj.send_admin_message(
                subject: subject,
                body_markdown: body_long_markdown_private,
              )
              @obj.send_reporter_message(
                subject: subject,
                body_short_markdown: body_short_markdown_private,
                body_long_markdown: body_long_markdown_private
              )
            end
          end
        end

        @comment = ""
        
        flash[:error] = t("myplaceonline.reputation_reports.comment_submitted")
      else
        flash[:error] = t("myplaceonline.reputation_reports.no_comment")
      end
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
        :allow_mediation,
        :public_story,
        reputation_report_files_attributes: FilesController.multi_param_names,
        agent_attributes: Agent.param_names,
      )
    end

    def admin_sees_all?
      true
    end
end
