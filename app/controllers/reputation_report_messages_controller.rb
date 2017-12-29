class ReputationReportMessagesController < MyplaceonlineController
  def path_name
    "reputation_report_reputation_report_message"
  end

  def form_path
    "reputation_report_messages/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.reputation_report_messages.back"),
        link: reputation_report_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.reputation_report_messages.back"),
        link: reputation_report_path(@obj.reputation_report),
        icon: "back"
      }
    ] + super
  end
  
  def after_update_redirect
    @obj.message.process
    super
  end
  
  def after_create_redirect
    @obj.message.process
    super
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.updated_at, User.current_user)
  end

  def show_index_add
    User.current_user.admin?
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:reputation_report_message).permit(ReputationReportMessage.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      ReputationReport
    end
    
    def admin_sees_all?
      true
    end
end
