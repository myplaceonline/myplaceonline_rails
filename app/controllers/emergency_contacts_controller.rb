class EmergencyContactsController < MyplaceonlineController
  def share_token
    @share = Myp.new_model(PermissionShare)
    @share.copy_self = true
    @share.subject_class = params[:subject_class]
    @share.subject_id = params[:subject_id]
    @share.child_selections = params[:child_selections]
    @share.email = Myp.new_model(Email)
    @share.email.email_category = @share.subject_class

    if @share.has_obj
      @check_obj = @share.get_obj
      authorize! :show, @check_obj
      check_obj_display = @check_obj.display
      @share.email.set_subject(Myp.object_type_human(@check_obj) + ": " + check_obj_display)
      @share.email.set_body_if_blank(check_obj_display)
    end

    if request.post?
      @share = PermissionShare.new(
        params.require(:permission_share).permit(
          :subject_class,
          :subject_id,
          :child_selections,
          email_attributes: EmailsController.param_names
        )
      )

      @check_obj = @share.get_obj
      authorize! :show, @check_obj

      @share.identity = User.current_user.current_identity
      
      public_share = Share.build_share(owner_identity: @share.identity)
      public_share.save!
      
      @share.share = public_share
      
      save_result = @share.save
      if save_result
        redirect_to(permission_shares_personalize_path(@share))
      end
    end
  end
  
  protected
    def obj_params
      params.require(:emergency_contact).permit(
        email_attributes: EmailsController.param_names
      )
    end
end
