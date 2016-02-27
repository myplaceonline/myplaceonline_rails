class UnsubscribeController < ApplicationController
  skip_before_filter :do_authenticate_user
  skip_authorization_check
  
  def index
  end
end
