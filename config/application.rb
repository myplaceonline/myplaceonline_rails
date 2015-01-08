require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myplaceonline
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    puts "Starting @ " + Time.now.to_s
    
    # http://stackoverflow.com/a/5015920/4135310
    config.before_configuration do
      I18n.locale = :en
      I18n.load_path += Dir[Rails.root.join('config', 'locales', 'en.yml').to_s]
      I18n.reload!
    end

    config.autoload_paths += %W(#{config.root}/lib)
    
    config.require_invite_code = ENV["REQUIRE_INVITE_CODE"].nil? ? false : (ENV["REQUIRE_INVITE_CODE"].eql? "true")
    
    config.invite_code = ENV["INVITE_CODE"].nil? ? "invitecode" : ENV["INVITE_CODE"]
    
    # http://ruby-doc.org/core-2.2.0/Time.html#method-i-strftime
    # http://api.rubyonrails.org/classes/Time.html
    # http://api.rubyonrails.org/classes/DateTime.html
    Date::DATE_FORMATS[:default] = "%Y-%m-%d"
    Time::DATE_FORMATS[:simple_date] = "%A, %b %d, %Y"
  end
end
