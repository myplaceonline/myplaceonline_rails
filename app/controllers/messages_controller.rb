class MessagesController < MyplaceonlineController
  
  def self.param_names
    [
      :id,
      :body,
      :long_body,
      :subject,
      :copy_self,
      :message_category,
      :draft,
      :send_preferences,
      message_contacts_attributes: [
        :id,
        :_destroy,
        contact_attributes: ContactsController.param_names
      ],
      message_groups_attributes: [
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
    I18n.t("myplaceonline.messages.send") + " " + I18n.t("myplaceonline.category." + category_name).singularize + "(s)"
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.messages.duplicate"),
        link: new_message_path(duplicate: @obj.id),
        icon: "plus"
      }
    ]
  end
  
  def index_filters
    super + [
      {
        :name => :draft,
        :display => "myplaceonline.messages.draft"
      }
    ]
  end
  
  protected
    def obj_params
      params.require(:message).permit(MessagesController.param_names)
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
                        I18n.t(@obj.send_immediately ? "myplaceonline.messages.send_sucess_sync" : "myplaceonline.messages.send_sucess_async")
                      }
    end

    def new_prerespond
      duplicate = params[:duplicate]
      if !duplicate.blank?
        duplicate_obj = Myp.find_existing_object(Message, duplicate)
        @obj.message_category = duplicate_obj.message_category
        @obj.body = duplicate_obj.body
        duplicate_obj.message_contacts.each do |message_contact|
          @obj.message_contacts << MessageContact.new(contact: message_contact.contact)
        end
        duplicate_obj.message_groups.each do |message_group|
          @obj.message_groups << MessageGroup.new(group: message_group.group)
        end
      end
    end
end
