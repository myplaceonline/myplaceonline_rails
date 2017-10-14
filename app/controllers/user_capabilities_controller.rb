class UserCapabilitiesController < MyplaceonlineController
  protected
    def obj_params
      params.require(:user_capability).permit(
        :capability
      )
    end

    def require_admin?
      true
    end
end
