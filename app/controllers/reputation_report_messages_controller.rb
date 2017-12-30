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
  
  def after_create_redirect
    @obj.message.process
    ensure_permissions
    super
  end

# We don't resend messages on update because the common use case is to 
# edit a message and add files (e.g. screenshots)  
#   def after_update_redirect
#     @obj.message.process
#     ensure_permissions
#     super
#   end
  
  def ensure_permissions
    if User.current_user.admin?
      @obj.message.message_contacts.each do |message_contact|
        if Permission.where(subject_class: Contact.name.underscore.pluralize, subject_id: message_contact.contact.id).take.nil?
          Permission.create!(
            action: Permission::ACTION_MANAGE,
            subject_class: Contact.name.underscore.pluralize,
            subject_id: message_contact.contact.id,
            identity_id: User.current_user.domain_identity,
            user_id: User.current_user.id,
          )
        end
      end
    end
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

  def show_add
    User.current_user.admin?
  end

  def may_upload
    true
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

    def build_new_model
      @obj.message = Message.build

      long_signature = Myp.website_domain_property("long_signature")
      short_signature = Myp.website_domain_property("short_signature")
      if !long_signature.blank? || !short_signature.blank?
        @obj.message.body = " (" + long_signature + ")"
        @obj.message.long_body = "\n\n" + long_signature
        @obj.message.suppress_signature = true
      end
    end
end
