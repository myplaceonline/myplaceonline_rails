class PermissionsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:share, :share_token]

  def self.param_names
    [
      :id,
      :_destroy,
      :subject_class,
      :subject_id,
      :actionbit1,
      :actionbit2,
      :actionbit4,
      :actionbit8,
      :actionbit16,
      user_attributes: [:id]
    ]
  end

  def share
    processed_params = Myp.process_param_braces(params)
    Rails.logger.debug{"Processed params: #{processed_params}"}
    @permission = Permission.new(
      processed_params.require(:permission).permit(
        PermissionsController.param_names
      )
    )
    @subject = I18n.t("myplaceonline.permissions.default_subject", {
      subject_class: @permission.category_display.singularize
    })
    @body = I18n.t("myplaceonline.permissions.default_body", {
      subject_class: @permission.category_display.singularize,
      contact: User.current_user.display,
      link: @permission.url
    })
    if request.post?
      save_result = @permission.save
      if save_result
        
        content = "<p>" + ERB::Util.html_escape_once(@body) + "</p>\n\n"
        content += "<p>" + ActionController::Base.helpers.link_to(@permission.url, @permission.url) + "</p>"
        
        cc = nil
        if @copy_self
          cc = User.current_user.email
        end
        to = [@permission.user.email]
        Myp.send_email(to, @subject, content.html_safe, cc)

        return redirect_to @permission.path,
          :flash => { :notice =>
                      I18n.t("myplaceonline.permissions.shared_sucess")
                    }
      end
    end
  end

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
      if @check_obj.respond_to?("additional_display")
        check_obj_display += @check_obj.additional_display
      end
      @share.email.set_subject(Myp.object_type_human(@check_obj) + ": " + check_obj_display)
      
      # We don't set a body because the body will usually have a link
      # with the object display anyway (see permission_share:send_email)
      # @share.email.set_body_if_blank(check_obj_display)
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

      @share.identity = User.current_user.primary_identity
      
      public_share = Share.new
      public_share.identity = @share.identity
      public_share.token = SecureRandom.hex(10)
      public_share.save!
      
      @share.share = public_share
      
      save_result = @share.save
      if save_result
        redirect_to(permission_share_personalize_path(@share))
      end
    end
  end
  
  protected
    def sorts
      ["permissions.updated_at DESC"]
    end

    def obj_params
      params.require(:permission).permit(
        PermissionsController.param_names
      )
    end
end
