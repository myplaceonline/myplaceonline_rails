class TherapistsController < MyplaceonlineController
  def footer_items_show
    result = []
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.contacts.add_conversation"),
        link: new_contact_conversation_path(@obj.contact),
        icon: "comment"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.contacts.conversations"),
      link: contact_conversations_path(@obj.contact),
      icon: "phone"
    }
    
    result + super
  end
  
  protected
    def obj_params
      params.require(:therapist).permit(
        contact_attributes: ContactsController.param_names
      )
    end
end
