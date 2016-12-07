class BadgesController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def n42
    render "42"
  end
end
