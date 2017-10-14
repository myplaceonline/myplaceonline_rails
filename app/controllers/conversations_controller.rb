class ConversationsController < MyplaceonlineController
  def path_name
    "contact_conversation"
  end

  def form_path
    "conversations/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.contacts.contact'),
        link: contact_path(@parent),
        icon: "user"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t('myplaceonline.contacts.contact'),
        link: contact_path(@obj.contact),
        icon: "user"
      }
    ]
  end
  
  def may_upload
    true
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.conversations.conversation_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["conversations.conversation_date"]
    end

    def obj_params
      params.require(:conversation).permit(
        :conversation,
        :conversation_date,
        conversation_files_attributes: FilesController.multi_param_names
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Contact
    end
end
