# This is the controller for the administrative view of users, not for
# the `devise` user stuff
class UsersController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:allusers]
  skip_before_action :before_all_actions, only: [:allusers]
  
  def show_index_footer
    false
  end
  
  def allow_add
    false
  end
  
  def allusers
    @objs = []
    if !params[:q].blank?
      @objs = User.where("lower(email) = ?", params[:q].strip.downcase)
      Rails.logger.debug{"allusers results: #{@objs.length}"}
    end
  end

  def use_bubble?
    true
  end

  def bubble_text(obj)
    Myp.display_date_short_year(obj.last_sign_in_at, current_user)
  end

  def footer_items_show
    result = super

    if !MyplaceonlineExecutionContext.offline? && User.current_user.admin?
      result << {
        title: I18n.t("myplaceonline.users.email"),
        link: user_email_path(@obj),
        icon: "mail"
      }
    end

    result
  end

  def email
    set_obj

    if request.post?
      subject = params[:subject]
      body = params[:body]

      if !subject.blank? && !body.blank?
        body_html = Myp.markdown_to_html(body)
        User.current_user.current_identity.send_email(
          subject,
          body_html,
          nil,
          nil,
          body
        )
        flash[:notice] = "Email queued"
      else
        flash[:error] = "Subject or body missing"
      end
    end
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.users.email"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(users.email)"]
    end

    def obj_params
      params.require(:user).permit(
        :email,
        :user_type
      )
    end

    def additional_items?
      false
    end

    def requires_admin
      true
    end
    
    def admin_sees_all?
      !MyplaceonlineExecutionContext.offline?
    end
end
