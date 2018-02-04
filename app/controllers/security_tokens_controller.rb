class SecurityTokensController < MyplaceonlineController
  protected
    def sensitive
      true
    end

    def obj_params
      params.require(:security_token).permit(
        :security_token_value,
        :notes,
        :available_uses,
      )
    end
end
