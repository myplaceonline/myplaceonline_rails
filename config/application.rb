require_relative "boot"

require "rails/all"

require "log4r"
require "log4r/yamlconfigurator"
require "log4r/outputter/datefileoutputter"
require "fileutils"
require "twilio-ruby"
include Log4r

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myplaceonline
  
  # The following section are mirrored in myplaceonline_final.js
  DEFAULT_DATE_FORMAT = "%A, %b %d, %Y"
  DEFAULT_TIME_FORMAT = "%A, %b %d, %Y %-l:%M:%S %p"
  JQM_DATEBOX_TIMEBOX_FORMAT = "%I:%M %p"
  # End mirrored constants

  class MyplaceonlineRack
    def initialize(app)
      @app = app
    end
    
    def call(env)
      
      # We could load up the user from warden, but that would mean we'd do a SQL request on all requests including
      # images, etc.
      
      # user = env["warden"].user
      
      # Instead, we just grab the user ID from warden's cookie
      warden_user_key = env["rack.session"]["warden.user.user.key"]
      user_id = warden_user_key.nil? ? -1 : warden_user_key[0][0]
      
      # Debug
      #awesome_print(env)
      
      Myp.log_response_time(
        name: "MyplaceonlineRack.call",
        uri: env["REQUEST_URI"],
        request_id: env["action_dispatch.request_id"],
        user_id: user_id
      ) do
        
        # Clear the contexts just in case somehow it wasn't cleared from the last request
        ExecutionContext.clear
        
        ExecutionContext.stack do
          
          # Save off any per-request info:
          
          # "SERVER_SOFTWARE" => "thin 1.7.1 codename Muffin Mode",
          # "SERVER_NAME" => "localhost",
          # "REQUEST_METHOD" => "GET",
          # "REQUEST_PATH" => "/",
          # "PATH_INFO" => "/",
          # "REQUEST_URI" => "/",
          # "HTTP_VERSION" => "HTTP/1.1",
          # "HTTP_HOST" => "localhost:3000",
          # "HTTP_USER_AGENT" => "curl/7.51.0",
          # "HTTP_ACCEPT" => "*/*",
          # "GATEWAY_INTERFACE" => "CGI/1.2",
          # "SERVER_PORT" => "3000",
          # "QUERY_STRING" => "",
          # "SERVER_PROTOCOL" => "HTTP/1.1",
          # "SCRIPT_NAME" => "",
          # "REMOTE_ADDR" => "127.0.0.1",
          # "ORIGINAL_FULLPATH" => "/",
          # "ORIGINAL_SCRIPT_NAME" => "",
          
          query_string = env["rack.request.query_string"]
          parsed_query_string = Rack::Utils.parse_nested_query(query_string)
          
          host = env["HTTP_HOST"]
          if host.nil?
            host = ""
          end
          if !host.index(':').nil?
            host = host.gsub(/:\d+$/, "")
          end
          if host == "localhost"
            host = ""
          end
          
          if !parsed_query_string["emulate_host"].blank?
            host = parsed_query_string["emulate_host"]
          end
          
          # See also https://github.com/knu/ruby-domain_name/
          if host.starts_with?("www.")
            host = host[4..-1]
          end
          
          # Internal, direct requests from things like Apache Bench to initialize a server:
          i = host.index("-internal.myplaceonline.com")
          if !i.nil?
            host = host[i + 10..-1]
          end
          
          MyplaceonlineExecutionContext.host = host
          MyplaceonlineExecutionContext.query_string = query_string
          MyplaceonlineExecutionContext.cookie_hash = env["rack.request.cookie_hash"]
          
          if parsed_query_string["current_identity_id"] != "-1"
            if !parsed_query_string["current_identity_id"].blank?
              cii = parsed_query_string["current_identity_id"].to_i
              user = env["warden"].user
              i = user.identities.index{|x| x.id == cii}
              if !i.nil?
                user.change_default_identity(user.identities[i])
              else
                raise "Invalid identity"
              end
            end
            
            #Rails.logger.debug{"MyplaceonlineRack.call setting context host: #{MyplaceonlineExecutionContext.host}, query_string: #{MyplaceonlineExecutionContext.query_string}, cookie_hash: #{Myp.debug_print(MyplaceonlineExecutionContext.cookie_hash)}"}
            
            @app.call(env)
          else
            request = ActionDispatch::Request.new(env)
            
            [
              302,
              {
                "Location": "#{request.protocol}#{request.host_with_port}/identities/new"
              },
              self,
            ]
          end
        end
      end
    end
    
    def each(&block)
    end
  end
  
  class Application < Rails::Application
    config.middleware.use(MyplaceonlineRack)
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    if ENV['USER'].blank?
      username = "nouser"
    else
      username = ENV['USER']
    end
    
    puts "Starting PID #{Process.pid} @ #{Time.now.to_s} from #{Dir.pwd.to_s} by #{username}"
    
    begin
      log4r_config = YAML.load_file(File.join(File.dirname(__FILE__), "log4r.yml"))
      log4r_config['log4r_config']['outputters'].each do |outputter|
        if outputter['filename']
          outputter['filename'] = outputter['filename'].gsub("%u", username)
          if Rails.env.production?
            # may need to know for perms, etc
            puts "Changing configuration of log4r outputter to " + File.absolute_path(Dir.new(outputter["dirname"])) + "/" + outputter['filename']
          end
        end
      end
      YamlConfigurator.decode_yaml( log4r_config['log4r_config'] )
      config.logger = Log4r::Logger[Rails.env]
    rescue Exception => e
      puts "Error configuring log4r #{e}"
    end
    
    # http://stackoverflow.com/a/5015920/4135310
    config.before_configuration do
      I18n.locale = :en
      I18n.load_path += Dir[Rails.root.join('config', 'locales', 'en.yml').to_s]
      I18n.reload!
    end

    # https://github.com/rails/rails/issues/13142
    # http://stackoverflow.com/a/40019108/5657303
    #config.eager_load_paths += %W(#{config.root}/lib)

    #config.tmpdir = ENV["TMPDIR"].blank? ? Dir.tmpdir : ENV["TMPDIR"]
    config.tmpdir = Rails.root.join("tmp", "myp").to_s
    config.filetmpdir = Rails.root.join("tmp", "myp", "files").to_s
    if !ENV["PERMDIR"].blank?
      config.filetmpdir = ENV["PERMDIR"] + "uploads"
    end

    FileUtils.mkdir_p(config.tmpdir)
    
    # IdentityFile has different logic if PERMDIR doesn't exist
    if Rails.env.production?
      FileUtils.mkdir_p(config.filetmpdir)
    end

    config.active_job.queue_adapter = :delayed_job
    
    # http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime
    # http://api.rubyonrails.org/classes/Time.html
    # http://api.rubyonrails.org/classes/DateTime.html
    Date::DATE_FORMATS[:default] = Myplaceonline::DEFAULT_DATE_FORMAT
    Time::DATE_FORMATS[:default] = Myplaceonline::DEFAULT_TIME_FORMAT
    
    Time::DATE_FORMATS[:month_year] = "%B %Y (%m/%y)"
    Time::DATE_FORMATS[:month_year_simple] = "%B %Y"
    Time::DATE_FORMATS[:simple_date] = Myplaceonline::DEFAULT_DATE_FORMAT
    Time::DATE_FORMATS[:short_date] = "%b %d"
    Time::DATE_FORMATS[:short_date_year] = "%b %d, %Y"
    Time::DATE_FORMATS[:short_datetime] = "%b %d %l:%M%p"
    Time::DATE_FORMATS[:short_datetime_year] = "%b %d %Y, %l:%M%p"
    Time::DATE_FORMATS[:super_short_datetime_year] = "%a %b %d %l:%M%p %Y"
    Time::DATE_FORMATS[:full] = "%FT%T%:z"
    Date::DATE_FORMATS[:just_year] = "%Y"
    
    # http://dev.jtsage.com/jQM-DateBox/api/timeOutput/
    Time::DATE_FORMATS[:timebox] = Myplaceonline::JQM_DATEBOX_TIMEBOX_FORMAT
    Time::DATE_FORMATS[:simple_time] = "%I:%M %p"
    
    # http://www.iso.org/iso/iso8601
    Date::DATE_FORMATS[:iso8601] = "%Y-%m-%d"
    Time::DATE_FORMATS[:iso8601] = "%Y-%m-%d"
    
    Date::DATE_FORMATS[:dygraph] = "%Y-%m-%d"
    Time::DATE_FORMATS[:dygraph] = "%Y-%m-%d %H:%M:%S"
    
    if !ENV["TWILIO_AUTH"].blank?
      config.middleware.use(Rack::TwilioWebhookAuthentication, ENV["TWILIO_AUTH"], "/api/twilio")
    end
  end
end
