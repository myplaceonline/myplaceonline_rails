# This is the controller for the administrative view of users, not for
# the `devise` user stuff
class UsersController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:allusers]
  
  def show_index_footer
    false
  end
  
  def show_add
    false
  end
  
  def allusers
    @objs = []
    if !params[:value].blank?
      @objs = User.where('lower(email) = ?', params[:value].strip.downcase)
    end
  end

  def use_bubble?
    true
  end

  def bubble_text(obj)
    Myp.display_date_short_year(obj.last_sign_in_at, current_user)
  end

  protected
    def all
      authorize! :manage, User
      User.all
    end
    
    def set_obj
      @obj = model.find_by(id: params[:id])
      authorize! :manage, @obj
    end

    def sorts
      ["lower(users.email) ASC"]
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
end
