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
  
  protected
    def sorts
      ["conversations.conversation_date DESC"]
    end

    def obj_params
      params.require(:conversation).permit(
        :conversation,
        :conversation_date
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
