class AdminController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_authorization_check

  before_action :check_admin_key
  
  def test
    render json: {
      :test => "Hello World"
    }
  end
  
  def ensure_pending_all_users
    CalendarItemReminder.ensure_pending_all_users
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
    TestJob.perform_later("hello world")
    render json: {
      :success => true
    }
  end
end
