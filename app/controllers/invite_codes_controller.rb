class InviteCodesController < MyplaceonlineController
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
        :max_uses
      )
    end

    def requires_admin
      true
    end

    def has_category
      false
    end
end
