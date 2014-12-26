class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

if Myp.is_web_server? || Rails.env.test?
  if ActiveRecord::Base.connection.table_exists?(Category.table_name)
    Myp.categories[:order] = Category.find_by(:name => :order)
    Myp.categories[:joy] = Category.find_by(:name => :joy)
    Myp.categories[:meaning] = Category.find_by(:name => :meaning)
    Myp.categories[:passwords] = Category.find_by(:name => :passwords)
    puts "Initialized categories succesfully"
  end
  
  if Rails.env.production?
    Myplaceonline::Application.config.session_store :cookie_store,
        :key => 'mypsession',
        :expire_after => 30.minutes
  end
end
