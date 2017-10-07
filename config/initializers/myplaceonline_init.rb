class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
  
  def integer?
    return self =~ /\A[+-]?\d+\Z/ ? true : false
  end
  
  def with_commas
    self.reverse.gsub(/\d{3}/,"\\&,").reverse.sub(/^,/,"")
  end
end

class Numeric
  def with_commas
    to_s.with_commas
  end
end

if Myp.is_web_server? || Rails.env.test?
  if Rails.env.production?
    Myplaceonline::Application.config.session_store :cookie_store,
        :key => "mypsession",
        :expire_after => 30.minutes
  end

  if Myp.database_exists? && !Rails.env.test?
    CalendarItemReminder.ensure_pending_all_users
  end
  
  ActiveSupport.on_load(:after_initialize) do
    # Initialize any caches after Rails has loaded so that we have access to things like the asset pipeline digests
    Myp.reinitialize_in_rails_context
  end
end
