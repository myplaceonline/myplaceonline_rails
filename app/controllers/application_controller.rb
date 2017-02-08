class ApplicationController < ActionController::Base
  respond_to :html, :json
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # By default, all pages require authentication unless the controller has
  #   skip_before_action :do_authenticate_user
  #before_action :authenticate_user!
  before_action :do_authenticate_user
  
  around_action :around_request
  
  #after_filter do puts "Response: " + response.body end
  
  before_action :set_time_zone
  
  check_authorization
  
  rescue_from StandardError, :with => :catchall
  
  utf8_enforcer_workaround
  
  def do_authenticate_user
    Rails.logger.debug{"do_authenticate_user entry"}

    catch_result = catch(:warden) do
      Rails.logger.debug{"calling authenticate_user!"}
      authenticate_user!
      Rails.logger.debug{"returned successfully"}
    end
    
    Rails.logger.debug{"catch_result: #{catch_result.inspect}"}

    # If catch_result is a Hash, then we assume it's {scope: :user} and
    # it's somebody trying to access a resource; otherwise, it might just be
    # somebody failing to login for some reason (e.g. password) and we
    # let that fall through (re-throw not needed)
    
    if catch_result.is_a?(Hash)
      # authenticate_user! failed
      
      Rails.logger.debug{"Setting user to guest: #{User.guest.inspect}"}
      
      warden.set_user(User.guest, {run_callbacks: false})

    #else
    #  throw :warden, catch_result

    end
  end

  def catchall(exception)
    Rails.logger.debug{"catchall: #{exception.inspect}"}
    if exception.is_a?(Myp::DecryptionKeyUnavailableError)
      redirect_to Myp.reentry_url(request)
    elsif exception.is_a?(CanCan::AccessDenied)
      redirect_to root_url, :alert => exception.message
    elsif exception.is_a?(Myp::SuddenRedirectError)
      if exception.notice.blank?
        redirect_to exception.path
      else
        redirect_to exception.path, :flash => { :notice => exception.notice }
      end
    else
      Myp.handle_exception(exception, session[:myp_email], request)
      respond_to do |type|
        #type.html { render :template => "errors/500", :status => 500 }
        #type.html { render :html => exception.to_s, :status => 500 }
        type.all { render :plain => exception.to_s, :status => 500 }
      end
      true
    end
  end

  def around_request
    Rails.logger.debug{"application_controller around_request entry. Referer: #{request.referer}"}
    
    Rails.logger.debug{"params: #{Myp.debug_print(params.to_unsafe_hash)}"}
    
    # This method is called once per controller, and multiple controllers might render within a single request.
    ExecutionContext.stack do
      
      # Once per request, save off some stuff into thread local storage
      if MyplaceonlineExecutionContext.request.nil?
        
        MyplaceonlineExecutionContext.request = instance_variable_get(:@_request)
        
        Rails.logger.debug{"Setting User.current_user: #{current_user.nil? ? "nil" : current_user.id}"}

        MyplaceonlineExecutionContext.user = current_user
        
        expire_asap = true

        if !current_user.nil?
          MyplaceonlineExecutionContext.request.session[:myp_email] = current_user.email
          
          if current_user.minimize_password_checks
            expire_asap = false
          end
        end

        MyplaceonlineExecutionContext.persistent_user_store = PersistentUserStore.new(
          cookies: cookies,
          expire_asap: expire_asap
        )
      end
      
      if !ENV["NODENAME"].blank?
        # Always set the SERVERID cookie so that if we explicitly target a server
        # with a query parameter, the new server sticks in spite of any previous
        # SERVERID cookies.
        cookies["SERVERID"] = {
          value: ENV["NODENAME"].gsub(/\..*$/, "")
        }
      end
      
      yield
    end
  end
  
  def set_time_zone
    if !current_user.nil? && !current_user.timezone.blank?
      begin
        Time.zone = current_user.timezone
      rescue Exception => e
        Myp.warn("Invalid time zone #{Myp.error_details(e)}")
      end
    end
  end

  def check_password(level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    MyplaceonlineController.check_password(current_user, session, level: level)
  end

  private
    # https://github.com/CanCanCommunity/cancancan/wiki/Accessing-request-data
    def current_ability
      @current_ability ||= Ability.new(current_user, request)
    end
end
