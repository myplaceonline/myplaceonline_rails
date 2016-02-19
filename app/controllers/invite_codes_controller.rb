class InviteCodesController < MyplaceonlineController
  protected
    def sorts
      ["lower(invite_codes.code) ASC"]
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
