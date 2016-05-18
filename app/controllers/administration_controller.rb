class AdministrationController < ApplicationController
  skip_authorization_check
  before_action :check_admin
  
  def index; end

  def check_admin
    if current_user.nil? || !current_user.admin?
      raise CanCan::AccessDenied.new("Not authorized")
    end
  end
end
