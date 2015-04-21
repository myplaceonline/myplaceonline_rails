class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # TODO broken with JQueryMobile on login/logout
  #protect_from_forgery with: :exception

  # By default, all pages require authentication unless the controller has
  #   skip_before_filter :authenticate_user!
  before_action :authenticate_user!
  
  around_filter :set_current_user
  
  around_filter :set_current_session
  
  #after_filter do puts "Response: " + response.body end
  
  before_filter :set_time_zone
  
  check_authorization
  
  rescue_from StandardError, :with => :catchall
  
  def catchall(exception)
    if exception.is_a?(Myp::DecryptionKeyUnavailableError)
      redirect_to Myp.reentry_url(request)
    elsif exception.is_a?(CanCan::AccessDenied)
      redirect_to root_url, :alert => exception.message
    else
      puts Myp.error_details(exception)
      respond_to do |type|
        #type.xml { render :template => "errors/error_404", :status => 500 }
        type.all { render :text => exception.to_s, :status => 500 }
      end
      true
    end
  end
  
  def set_current_user
    User.current_user = current_user
    yield
  ensure
    User.current_user = nil
  end
  
  def set_current_session
    request_accessor = instance_variable_get(:@_request)
    Thread.current[:current_session] = request_accessor.session
    yield
  ensure
    Thread.current[:current_session] = nil
  end
  
  def self.current_session
    Thread.current[:current_session]
  end
  
  def set_time_zone
    if !current_user.nil? && !current_user.timezone.blank?
      Time.zone = current_user.timezone
    end
  end
end
