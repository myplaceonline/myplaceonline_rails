class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # By default, all pages require authentication unless the controller has
  #   skip_before_filter :authenticate_user!
  before_action :authenticate_user!
  
  rescue_from Myp::DecryptionKeyUnavailableError do |exception|
    redirect_to "/users/reenter", :flash => { :error => I18n.t("myplaceonline.errors.nosessionpassword") }
  end
end
