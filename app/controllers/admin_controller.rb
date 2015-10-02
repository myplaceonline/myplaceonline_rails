class AdminController < ApplicationController

  skip_authorization_check
  
  before_action :check_admin_key
  
  def test
    render json: {
      :test => "Hello World"
    }
  end
  
  def recalculate_all_users_due
    DueItem.recalculate_all_users_due
    render json: {
      :success => true
    }
  end
  
  def check_admin_key
    if Rails.env.production?
      puts "DEBUG: " + ENV["SECRET_KEY_BASE"].inspect + ";" + params[:key].inspect
      if ENV["SECRET_KEY_BASE"] != params[:key]
        raise CanCan::AccessDenied.new("Not authorized")
      end
    end
  end
end
