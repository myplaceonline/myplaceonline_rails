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

    def additional_sorts
      [
        [I18n.t("myplaceonline.drafts.draft_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(drafts.draft_name)"]
    end

    def obj_params
      params.require(:draft).permit(
        :draft_name,
        :notes
      )
    end
end
