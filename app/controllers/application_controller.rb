class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # TODO broken with JQueryMobile on login/logout
  #protect_from_forgery with: :exception

  # By default, all pages require authentication unless the controller has
  #   skip_before_filter :authenticate_user!
  before_action :authenticate_user!
  
  around_filter :around_request
  
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
      Myp.handle_exception(exception, session[:myp_email], request)
      respond_to do |type|
        #type.xml { render :template => "errors/error_404", :status => 500 }
        type.all { render :text => exception.to_s, :status => 500 }
      end
      true
    end
  end
  
  def around_request
    request_accessor = instance_variable_get(:@_request)
    User.current_user = current_user
    Thread.current[:current_session] = request_accessor.session
    if !current_user.nil?
      request_accessor.session[:myp_email] = current_user.email
    end
    Thread.current[:request] = request_accessor
    yield
  ensure
    User.current_user = nil
    Thread.current[:current_session] = nil
    Thread.current[:request] = nil
  end
  
  def self.current_session
    Thread.current[:current_session]
  end
  
  def self.current_request
    Thread.current[:request]
  end
  
  def set_time_zone
    if !current_user.nil? && !current_user.timezone.blank?
      Time.zone = current_user.timezone
    end
  end
end
