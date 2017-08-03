class TextMessagesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:unsubscribe]
  
  def self.param_names
    [
      :id,
      :body,
      :copy_self,
      :message_category,
      :draft,
      text_message_contacts_attributes: [
        :id,
        :_destroy,
        contact_attributes: ContactsController.param_names
      ],
      text_message_groups_attributes: [
        :id,
        :_destroy,
        group_attributes: GroupsController.param_names
      ]
    ]
  end
  
  def after_update_redirect
    if !@obj.draft
      @obj.process
    end
    super
  end
  
  def after_create_redirect
    if !@obj.draft
      @obj.process
    end
    super
  end
  
  def redirect_to_obj
    if !@obj.draft
      final_redirect
    else
      super
    end
  end

  def index
    @draft = params[:draft]
    if !@draft.blank?
      @draft = @draft.to_bool
    end
    super
  end

  def new_save_text
    I18n.t("myplaceonline.text_messages.send") + " " + I18n.t("myplaceonline.category." + category_name).singularize + "(s)"
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.text_messages.duplicate"),
        link: new_text_message_path(duplicate: @obj.id),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.trips.show_shared"),
        link: text_message_shared_path(@obj),
        icon: "search"
      },
    ]
  end
  
  def index_filters
    super + [
      {
        :name => :draft,
        :display => "myplaceonline.text_messages.draft"
      }
    ]
  end
  
  def shared
    set_obj
    @token = TextMessageToken.where(token: params[:token]).first
    @from = CGI::escapeHTML(@obj.identity.display)
    if !@obj.identity.user.nil?
      @from = "#{@from} (#{ActionController::Base.helpers.mail_to(@obj.identity.user.email)})"
    end
    from_number = @obj.identity.first_mobile_number
    if !from_number.nil?
      @from = "#{@from} (#{ActionController::Base.helpers.link_to(from_number.number, "tel:#{from_number.number}")})"
    end
    @from = @from.html_safe
  end
  
  def unsubscribe
    category = params[:category]
    token = params[:token]
    
    @content = ""
    
    token = TextMessageToken.where(token: token).first
    
    if !token.nil?
      flash.clear
      
      phone_number = token.phone_number
      
      if TextMessageUnsubscription.where(phone_number: phone_number, category: category, identity: token.identity).count == 0
        TextMessageUnsubscription.create!(
          phone_number: phone_number,
          category: category,
          identity: token.identity,
        )
      end
      
      if category.blank?
        @content = t("myplaceonline.text_messages.unsubscribed_all")
      else
        @content = t("myplaceonline.text_messages.unsubscribed_category", {category: category})
      end
      
    else
      flash[:error] = t("myplaceonline.unsubscribe.invalid_token")
    end
  end
  
  protected
    def sorts
      ["text_messages.updated_at DESC"]
    end

    def obj_params
      params.require(:text_message).permit(TextMessagesController.param_names)
    end

    def all_additional_sql(strict)
      if @draft && !strict
        "and draft = true"
      else
        nil
      end
    end
        
    def final_redirect
      redirect_to obj_path,
            :flash => { :notice =>
                        I18n.t(@obj.send_immediately ? "myplaceonline.text_messages.send_sucess_sync" : "myplaceonline.text_messages.send_sucess_async")
                      }
    end

    def new_prerespond
      duplicate = params[:duplicate]
      if !duplicate.blank?
        duplicate_obj = Myp.find_existing_object(TextMessage, duplicate)
        @obj.message_category = duplicate_obj.message_category
        @obj.body = duplicate_obj.body
        duplicate_obj.text_message_contacts.each do |text_message_contact|
          @obj.text_message_contacts << TextMessageContact.new(contact: text_message_contact.contact)
        end
        duplicate_obj.text_message_groups.each do |text_message_group|
          @obj.text_message_groups << TextMessageGroup.new(group: text_message_group.group)
        end
      end
    end
end
