class TextMessagesController < MyplaceonlineController
  
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
  
  def after_create_or_update
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
