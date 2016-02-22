class WelcomeController < ApplicationController
  skip_before_filter :do_authenticate_user
  skip_authorization_check
  
  def index
    if user_signed_in?
      @myplets = Myplet.where(identity: current_user.primary_identity).order(:x_coordinate, :y_coordinate).all
    end
  end
end
