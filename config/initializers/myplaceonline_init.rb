class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

if Myp.is_web_server? || Rails.env.test?
  if Rails.env.production?
    Myplaceonline::Application.config.session_store :cookie_store,
        :key => 'mypsession',
        :expire_after => 30.minutes
  end

  if Myp.database_exists? && !Rails.env.test?
    CalendarItemReminder.ensure_pending_all_users
    if !ENV["FTS_TARGET"].blank?
      puts "Configuring full text search with #{ENV["FTS_TARGET"]}"
      Chewy.root_strategy = :active_job
      Chewy.settings = {host: ENV["FTS_TARGET"]}
    end
  end
end
