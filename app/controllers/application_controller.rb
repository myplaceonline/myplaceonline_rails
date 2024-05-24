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

  after_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    #headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    #headers['Access-Control-Allow-Headers'] = '*'
    #headers['Access-Control-Max-Age'] = "1728000"
  end
  
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
    
    # https://github.com/rails/rails/issues/41783
    if request.format.html? && exception.message == "invalid base64"
      request.reset_session
      redirect_to "/users/sign_in"
    elsif request.xhr? && exception.message == "invalid base64"
      request.reset_session
      render js: "window.location = '/users/sign_in'"
    else
      if exception.is_a?(ActionView::Template::Error)
        exception = exception.cause
      end
    
      begin
        Rails.logger.warn{"ApplicationController.catchall exception details: #{Myp.error_details(exception)}"}
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
        Rails.logger.debug{"ApplicationController.catchall access denied #{exception.message} for #{User.current_user.inspect}".red}
        if User.current_user.nil? || User.current_user.guest?
          reentry_url = Myp.encoded_fullpath(request)
          Rails.logger.debug{"ApplicationController.catchall redirecting to #{reentry_url}".red}
          respond_to do |format|
            # curl -H "Accept: application/json"
            format.any(:js, :json) {
              render(
                json: {
                  status: I18n.t("myplaceonline.general.access_denied_guest"),
                  location: main_app.new_user_session_url(redirect: reentry_url),
                },
                status: 403,
              )
            }
            format.all {
              redirect_to(main_app.new_user_session_url(redirect: reentry_url), alert: I18n.t("myplaceonline.general.access_denied_guest"))
            }
          end
        else
          respond_to do |format|
            # curl -H "Accept: application/json"
            format.any(:js, :json) {
              render(
                json: {
                  status: I18n.t("myplaceonline.general.access_denied", resource: request.path),
                  location: main_app.root_url,
                },
                status: 403,
              )
            }
            format.all {
              redirect_to(main_app.root_url, alert: I18n.t("myplaceonline.general.access_denied", resource: request.path))
            }
          end
        end
      elsif exception.is_a?(Myp::SuddenRedirectError)
        Rails.logger.debug{"ApplicationController.catchall sudden redirect #{exception.path}".red}
      
        new_path = exception.path
      
        if !request.params[:emulate_host].blank?
          new_path << "?emulate_host=" + request.params[:emulate_host]
        end
      
        if exception.notice.blank?
          redirect_to(new_path)
        else
          redirect_to(new_path, :flash => { :notice => exception.notice })
        end
      elsif exception.is_a?(ActionController::InvalidAuthenticityToken)
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
  end

  def around_request
    Rails.logger.debug{"ApplicationController.around_request entry. Referer: #{request.referer}"}
    
    Rails.logger.debug{"ApplicationController.around_request params: #{Myp.debug_print(params.to_unsafe_hash)}"}
    
    # If current_user is not set in the execution context stack, then we set it
    # once without a stack frame because it might be needed in the exception
    # handler. The whole execution context is reset at the beginning of every
    # request.
    if MyplaceonlineExecutionContext.user.nil?
      MyplaceonlineExecutionContext.user = current_user.nil? ? User.guest : current_user
    end
    
    # This method is called once per controller, and multiple controllers might render within a single request.
    ExecutionContext.stack do
      
      # Once per request, save off some stuff into thread local storage
      if !MyplaceonlineExecutionContext.initialized
        expire_asap = true
        if !current_user.nil? && current_user.minimize_password_checks?
          expire_asap = false
        end

        request = instance_variable_get(:@_request)
        
        Rails.logger.debug{"ApplicationController.around_request initializing"}
        
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
        #cookies["SERVERID"] = DynamicCookieOptions.create_cookie_options.merge(
        #  {
        #    value: ENV["NODENAME"].gsub(/\..*$/, "")
        #  }
        #)
      end
      
      if !params[:emulate_host].blank?
        # http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
        cookies[:emulate_host] = DynamicCookieOptions.create_cookie_options.merge(
          {
            value: params[:emulate_host]
          }
        )
      end
      
      yield
    end
  end
  
  def set_time_zone
    if !current_user.nil? && !current_user.timezone.blank?
      begin
        # This is thread safe
        Time.zone = current_user.timezone
      rescue Exception => e
        Myp.warn("Invalid time zone #{Myp.error_details(e)}", e, request: request)
      end
    end
  end

  def check_password(level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    MyplaceonlineController.check_password(current_user, session, level: level)
  end
  
  def after_sign_out_path_for(resource)
    root_url + "?logged_out=true"
  end

  protected

    # respond_type: [download, inline]
    def respond_identity_file(respond_type, identity_file, filename = nil, content_type = nil, thumbnail: false, thumbnail2: false, cacheType: "private", cacheAgeSeconds: 43200)
      if !identity_file.file_file_name.blank?
        
        send_from_memory = true
        
        if !identity_file.filesystem_path.blank? && !thumbnail && !thumbnail2
          send_from_memory = false
        elsif !identity_file.thumbnail_filesystem_path.blank? && thumbnail
          send_from_memory = false
          
          # If the file doesn't exist, don't fall back to memory since it's
          # probably not there. Not sure why this code was put in in the first
          # place.
          
          # else
          #   if !File.exist?(identity_file.evaluated_path)
          #     send_from_memory = true
          #   end
        elsif !identity_file.thumbnail2_filesystem_path.blank? && thumbnail2
          send_from_memory = false
        end
        
        if send_from_memory
          Rails.logger.debug{"ApplicationController.respond_identity_file: #{identity_file.id} sending from memory"}
          
          if thumbnail
            respond_data(
              respond_type,
              identity_file.thumbnail_contents,
              identity_file.thumbnail_size_bytes,
              identity_file.thumbnail_name,
              identity_file.thumbnail_content_type,
              cacheType: cacheType,
              cacheAgeSeconds: cacheAgeSeconds,
            )
          elsif thumbnail2
            respond_data(
              respond_type,
              identity_file.thumbnail2_contents,
              identity_file.thumbnail2_size_bytes,
              identity_file.thumbnail_name,
              identity_file.thumbnail_content_type,
              cacheType: cacheType,
              cacheAgeSeconds: cacheAgeSeconds,
            )
          else
            respond_data(
              respond_type,
              identity_file.get_file_contents,
              identity_file.file_file_size,
              identity_file.file_file_name,
              identity_file.file_content_type,
              cacheType: cacheType,
              cacheAgeSeconds: cacheAgeSeconds,
            )
          end
        else
          Rails.logger.debug{"ApplicationController.respond_identity_file: Sending from #{identity_file.filesystem_path}"}
          
          if filename.nil?
            filename = identity_file.file_file_name
          end
          
          if content_type.nil?
            content_type = identity_file.file_content_type
          end
          
          if thumbnail || thumbnail2
            content_type = identity_file.thumbnail_content_type
            filename = identity_file.thumbnail_name
          end
          
          if thumbnail
            identity_file.ensure_thumbnail
            path = identity_file.evaluated_thumbnail_path
          elsif thumbnail2
            identity_file.ensure_thumbnail2
            path = identity_file.evaluated_thumbnail2_path
          else
            path = identity_file.evaluated_path
          end
          
          if File.exist?(path)
            
            response.set_header('Content-Length', "#{File.size(path)}")

            if cacheType == "public"
              expires_in(cacheAgeSeconds, public: true)
            else
              expires_in(cacheAgeSeconds, public: false)
            end

            send_file(
              path,
              type: content_type,
              filename: filename,
              disposition: respond_type,
            )
          else
            Rails.logger.debug{"ApplicationController.respond_identity_file: Sending 404 for #{path}"}
            head 404
          end
        end
      else
        Rails.logger.debug{"ApplicationController.respond_identity_file: Sending 404 for #{path} for bad file #{identity_file}"}
        head 404
      end
    end
    
    # respond_type: [download, inline]
    def respond_data(respond_type, data, data_bytes, filename, content_type, cacheType: "private", cacheAgeSeconds: 43200)
      Rails.logger.debug{"ApplicationController.respond_data respond_type: #{respond_type}, filename: #{filename}, content_type: #{content_type}"}
      response.headers["Content-Length"] = data_bytes.to_s
      if cacheType == "public"
        expires_in(cacheAgeSeconds, public: true)
      else
        expires_in(cacheAgeSeconds, public: false)
      end
      send_data(
        data,
        type: content_type,
        filename: filename,
        disposition: respond_type,
      )
    end

  private
  
    # https://github.com/CanCanCommunity/cancancan/wiki/Accessing-request-data
    def current_ability
      @current_ability ||= Ability.new(current_user, request)
    end
end
