class DynamicCookieOptions
  def initialize(params = {})
    @params = params
  end
  
  def method_missing(name, *args, &block)
    @params.merge!(DynamicCookieOptions.create_cookie_options)
    @params.send(name, *args, &block)
  end
  
  def self.cookie_domain
    domain = "localhost"
    if ExecutionContext.available?
      if Rails.env.production?
        domain = Myp.top_host
      end
    end
    domain
  end
  
  def self.create_cookie_options
    {
      domain: DynamicCookieOptions.cookie_domain,
      httponly: true,
      secure: Rails.env.production?
    }
  end
  
  def self.delete_cookie_options
    {
      domain: DynamicCookieOptions.cookie_domain,
    }
  end
end
