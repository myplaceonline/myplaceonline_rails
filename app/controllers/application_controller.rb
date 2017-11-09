require 'colorize'

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
  
  #utf8_enforcer_workaround
  
  def do_authenticate_user
    Rails.logger.debug{"ApplicationController.do_authenticate_user entry"}

    catch_result = catch(:warden) do
      Rails.logger.debug{"ApplicationController.do_authenticate_user calling authenticate_user!"}
      authenticate_user!
      Rails.logger.debug{"ApplicationController.do_authenticate_user returned successfully"}
    end
    
    Rails.logger.debug{"ApplicationController.do_authenticate_user catch_result: #{catch_result.inspect}"}

    # If catch_result is a Hash, then we assume it's {scope: :user} and
    # it's somebody trying to access a resource; otherwise, it might just be
    # somebody failing to login for some reason (e.g. password) and we
    # let that fall through (re-throw not needed)
    
    if catch_result.is_a?(Hash)
      # authenticate_user! failed
      
      Rails.logger.debug{"ApplicationController.do_authenticate_user Setting user to guest: #{User.guest.inspect}"}
      
      warden.set_user(User.guest, {run_callbacks: false})

    #else
    #  throw :warden, catch_result

    end
  end

  def catchall(exception)
    Rails.logger.warn{"ApplicationController.catchall: #{exception.inspect}".red}
    
    if exception.is_a?(ActionView::Template::Error)
      exception = exception.cause
    end
    
    begin
      Rails.logger.warn{"ApplicationController.catchall exception details: #{Myp.error_details(exception)} #{Thread.current[:debug]}"}
    rescue => e
    end
    
    if exception.is_a?(Myp::DecryptionKeyUnavailableError)
      reentry_url = Myp.reentry_url(request)
      Rails.logger.debug{"ApplicationController.catchall redirecting to: #{reentry_url}".red}
      respond_to do |format|
        format.html {
          Rails.logger.debug{"ApplicationController.catchall format html".red}
          redirect_to reentry_url
        }
        format.js {
          Rails.logger.debug{"ApplicationController.catchall format js".red}
          render js: "myplaceonline.navigate(\"#{reentry_url}\");"
        }
      end
    elsif exception.is_a?(CanCan::AccessDenied)
      Rails.logger.debug{"ApplicationController.catchall access denied #{exception.message}".red}
      if User.current_user.nil? || User.current_user.guest?
        redirect_to(new_user_session_url(redirect: request.fullpath), alert: I18n.t("myplaceonline.general.access_denied_guest"))
      else
        redirect_to(root_url, alert: I18n.t("myplaceonline.general.access_denied", resource: request.path))
      end
    elsif exception.is_a?(Myp::SuddenRedirectError)
      Rails.logger.debug{"ApplicationController.catchall sudden redirect #{exception.path}".red}
      if exception.notice.blank?
        redirect_to exception.path
      else
        redirect_to exception.path, :flash => { :notice => exception.notice }
      end
    else
      Rails.logger.debug{"ApplicationController.catchall unknown".red}
      Myp.handle_exception(exception, session[:myp_email], request)
      if Rails.env.test?
        raise exception
      end
      respond_to do |type|
        #type.html { render :template => "errors/500", :status => 500 }
        #type.html { render :html => exception.to_s, :status => 500 }
        #type.all { render :plain => exception.to_s + (Rails.env.production? ? "" : "\n#{Myp.error_details(exception)}"), :status => 500 }
        type.all { render :plain => exception.to_s, :status => 500 }
      end
      true
    end
  end

  def around_request
    Rails.logger.debug{"ApplicationController.around_request entry. Referer: #{request.referer}"}
    
    Rails.logger.debug{"ApplicationController.around_request params: #{Myp.debug_print(params.to_unsafe_hash)}"}
    
    # This method is called once per controller, and multiple controllers might render within a single request.
    ExecutionContext.stack do
      
      # Once per request, save off some stuff into thread local storage
      if !MyplaceonlineExecutionContext.initialized
        expire_asap = true
        if !current_user.nil? && current_user.minimize_password_checks
          expire_asap = false
        end

        request = instance_variable_get(:@_request)
        
        MyplaceonlineExecutionContext.initialize(
          request: request,
          session: request.session,
          user: current_user.nil? ? User.guest : current_user,
          persistent_user_store: PersistentUserStore.new(
            cookies: cookies,
            expire_asap: expire_asap
          )
        )
        
        MyplaceonlineExecutionContext.initialized = true
      end
      
      if !ENV["NODENAME"].blank?
        # Always set the SERVERID cookie so that if we explicitly target a server
        # with a query parameter, the new server sticks in spite of any previous
        # SERVERID cookies.
        cookies["SERVERID"] = DynamicCookieOptions.create_cookie_options.merge(
          {
            value: ENV["NODENAME"].gsub(/\..*$/, "")
          }
        )
      end
      
      yield
    end
  end
  
  def set_time_zone
    if !current_user.nil? && !current_user.timezone.blank?
      begin
        Time.zone = current_user.timezone
      rescue Exception => e
        Myp.warn("Invalid time zone #{Myp.error_details(e)}", e, request: request)
      end
    end
  end

  def check_password(level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    MyplaceonlineController.check_password(current_user, session, level: level)
  end
  
  protected

    # respond_type: [download, inline]
    def respond_identity_file(respond_type, identity_file, filename = nil, content_type = nil, thumbnail: false)
      
      send_from_memory = false
      if identity_file.filesystem_path.blank?
        send_from_memory = true
      else
        if !File.exist?(identity_file.evaluated_path)
          send_from_memory = true
        end
      end
      
      if send_from_memory
        Rails.logger.debug{"ApplicationController.respond_identity_file: #{identity_file.id} Not on the filesystem"}
        respond_data(
          respond_type,
          identity_file.get_file_contents,
          identity_file.file_file_size,
          identity_file.file_file_name,
          identity_file.file_content_type
        )
      else
        Rails.logger.debug{"ApplicationController.respond_identity_file: Sending from #{identity_file.filesystem_path}"}
        if filename.nil?
          filename = identity_file.file_file_name
        end
        if content_type.nil?
          content_type = identity_file.file_content_type
        end
        
        if !thumbnail
          path = identity_file.evaluated_path
        else
          path = identity_file.evaluated_thumbnail_path
        end
        
        send_file(
          path,
          :type => content_type,
          :filename => filename,
          :disposition => respond_type
        )
      end
    end
    
    # respond_type: [download, inline]
    def respond_data(respond_type, data, data_bytes, filename, content_type)
      response.headers["Content-Length"] = data_bytes.to_s
      send_data(
        data,
        :type => content_type,
        :filename => filename,
        :disposition => respond_type
      )
    end

  private
  
    # https://github.com/CanCanCommunity/cancancan/wiki/Accessing-request-data
    def current_ability
      @current_ability ||= Ability.new(current_user, request)
    end
end
