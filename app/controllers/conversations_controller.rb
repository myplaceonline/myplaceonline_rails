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
