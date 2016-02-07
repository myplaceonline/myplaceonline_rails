class PermissionsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:share]

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
    @permission = Permission.new(
      params.require(:permission).permit(
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
    @copy_self = true
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
