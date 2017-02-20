class TherapistsController < MyplaceonlineController
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.contacts.add_conversation"),
        link: new_contact_conversation_path(@obj.contact),
        icon: "comment"
      },
      {
        title: I18n.t("myplaceonline.contacts.conversations"),
        link: contact_conversations_path(@obj.contact),
        icon: "phone"
      }
    ] + super
  end
  
  protected
    def sorts
      ["therapists.updated_at DESC"]
    end

    def obj_params
      params.require(:therapist).permit(
        contact_attributes: ContactsController.param_names
      )
    end
end
