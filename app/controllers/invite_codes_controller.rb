class InviteCodesController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.website_domain.nil? ? nil : obj.website_domain.display
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.invite_codes.code"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(invite_codes.code)"]
    end

    def obj_params
      params.require(:invite_code).permit(
        :code,
        :current_uses,
        :max_uses,
        website_domain_attributes: [:id],
      )
    end

    def requires_admin
      true
    end

    def has_category
      false
    end
end
