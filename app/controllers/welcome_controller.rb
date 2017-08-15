class WelcomeController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index
    if user_signed_in?
      @myplets = Myplet.where(identity: current_user.primary_identity).order(:x_coordinate, :y_coordinate).all
    end
    
    if !params[:emulate_host].blank?
      # http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
      cookies[:emulate_host] = {
        value: params[:emulate_host]
      }
    end
  end
end
