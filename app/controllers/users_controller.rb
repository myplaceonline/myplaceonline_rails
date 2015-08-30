# This is the controller for the administrative view of users, not for
# the `devise` user stuff
class UsersController < MyplaceonlineController
  
  def show_index_footer
    false
  end
  
  def show_add
    false
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
end
