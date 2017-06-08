class UserCapabilitiesController < MyplaceonlineController
  protected
    def sorts
      ["user_capabilities.updated_at DESC"]
    end

    def obj_params
      params.require(:user_capability).permit(
        :capability
      )
    end

    def require_admin?
      true
    end
end
