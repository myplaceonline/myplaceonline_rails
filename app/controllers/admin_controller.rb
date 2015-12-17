class AdminController < ApplicationController

  skip_before_filter :authenticate_user!
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
      if ENV["SECRET_KEY_BASE"] != params[:key]
        raise CanCan::AccessDenied.new("Not authorized")
      end
    end
  end
  
  def create_test_job
    AdminJob.perform_later("hello world")
  end
end
