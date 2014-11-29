class ContactController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check
  
  def index
  end
end
