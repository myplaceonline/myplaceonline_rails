class EnteredInviteCodesController < MyplaceonlineController
  def after_create_redirect
    if User.current_user.current_identity.nil?
      redirect_to(root_path)
    else
      super
    end
  end
  
  protected
    def obj_params
      params.require(:entered_invite_code).permit(
        :code,
      )
    end

    def context_column
      "user_id"
    end
    
    def context_value
      current_user.id
    end
    
    def has_category
      false
    end

    def check_archived
      false
    end
end
