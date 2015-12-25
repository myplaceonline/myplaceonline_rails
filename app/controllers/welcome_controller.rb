class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check
  
  def index
    if user_signed_in?
      @myplets = Myplet.where(owner: current_user.primary_identity).order(:x_coordinate, :y_coordinate).all
    end
    @isInitialPhonegapRequest = Myp.is_phonegap_request(params, session)
    if @isInitialPhonegapRequest
      # TODO this is reset if user signs out (need to "transfer" such
      # session attributes)
      session[:phonegap] = true
    end
  end
end
