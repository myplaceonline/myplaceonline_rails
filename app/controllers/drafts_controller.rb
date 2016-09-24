class DraftsController < MyplaceonlineController
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.drafts.email"),
        link: new_email_path(email_source_class: @obj.class.name, email_source_id: @obj.id, email_source_body_field: :notes),
        icon: "action"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(drafts.draft_name) ASC"]
    end

    def obj_params
      params.require(:draft).permit(
        :draft_name,
        :notes
      )
    end
end
