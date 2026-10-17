require_relative "boot"

require "rails/all"

require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
require 'fileutils'
require 'twilio-ruby'
include Log4r

# Load any engine gems
Dir[Pathname.new(File.dirname(__FILE__)).join("../engines/**")].each do |engine|
  require File.basename(engine)
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myplaceonline
  
  # The following section are mirrored in myplaceonline_final.js
  DEFAULT_DATE_FORMAT = "%A, %b %d, %Y"
  DEFAULT_TIME_FORMAT = "%A, %b %d, %Y %-l:%M:%S %p"
  JQM_DATEBOX_TIMEBOX_FORMAT = "%I:%M %p"
  # End mirrored constants
  
  class Application < Rails::Application
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    
    # Rails 7.0 changed some defaults but keep some older behavior
    config.active_record.partial_inserts = true
    config.action_dispatch.cookies_serializer = :hybrid
    config.active_support.disable_to_s_conversion = false
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc

    # Raises error for missing translations
    config.i18n.raise_on_missing_translations = false
    config.active_record.belongs_to_required_by_default = false
    config.eager_load = true
    
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks generators middleware myputils])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    require "middleware/myplaceonline_middleware"
    config.middleware.use(MyplaceonlineMiddleware)
    
    require "myputils/dynamic_cookie_options"
    require "myputils/execution_context"
    require "myputils/myplaceonline_execution_context"
    require "myputils/myp_utils"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    if ENV['USER'].blank?
      username = "nouser"
    else
      username = ENV['USER']
    end
    
    puts "Starting PID #{Process.pid} @ #{Time.now.to_s} from #{Dir.pwd.to_s} by #{username}"
    
    use_log4r = false
    
    if use_log4r
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

    if Rails.env.production?
      config.active_job.queue_adapter = :delayed_job
    else
      config.active_job.queue_adapter = :async
    end
    
    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.plural /^(headache)$/i, '\1s'
      inflect.singular /^(headache)s/i, '\1'
      
      inflect.irregular 'foot', 'feet'
      inflect.irregular 'cafe', 'cafes'
      inflect.irregular 'regimen', 'regimens'
    end
    
    # http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime
    # http://api.rubyonrails.org/classes/Time.html
    # http://api.rubyonrails.org/classes/DateTime.html
    Date::DATE_FORMATS[:default] = Myplaceonline::DEFAULT_DATE_FORMAT
    Time::DATE_FORMATS[:default] = Myplaceonline::DEFAULT_TIME_FORMAT
    
    Time::DATE_FORMATS[:month_year] = "%B %Y (%m/%y)"
    Time::DATE_FORMATS[:month_year_simple] = "%B %Y"
    Time::DATE_FORMATS[:simple_date] = Myplaceonline::DEFAULT_DATE_FORMAT
    Time::DATE_FORMATS[:short_date] = "%b %e"
    Time::DATE_FORMATS[:short_date_year] = "%b %e, %Y"
    Time::DATE_FORMATS[:short_datetime] = "%b %e %l:%M%p"
    Time::DATE_FORMATS[:short_datetime_year] = "%b %e %Y, %l:%M%p"
    Time::DATE_FORMATS[:super_short_datetime_year] = "%a %b %e %l:%M%p %Y"
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
    
    Time::DATE_FORMATS[:short_time] = "%l:%M %p"

    if !ENV["TWILIO_AUTH"].blank?
      config.middleware.use(Rack::TwilioWebhookAuthentication, ENV["TWILIO_AUTH"], "/api/twilio")
    end
  end
end
