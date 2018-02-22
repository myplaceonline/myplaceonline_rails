# http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
class PersistentUserStore
  
  COOKIE_PREFIX = "rails_user"
  
  def initialize(cookies:, expire_asap:)
    @cookies = cookies
    @expire_asap = expire_asap
  end
  
  def []=(name, val)
    name = cookie_name(name: name)
    #Rails.logger.debug{"PersistentUserStore set name: #{name}, value: #{val}, expire_asap: #{@expire_asap}"}
    if @expire_asap
      @cookies.encrypted[name] = DynamicCookieOptions.create_cookie_options.merge(
        {
          value: val,
        }
      )
    else
      @cookies.encrypted[name] = DynamicCookieOptions.create_cookie_options.merge(
        {
          value: val,
          expires: Myp::MAX_COOKIE_EXPIRES_DATE,
        }
      )
    end
  end
  
  def [](name)
    name = cookie_name(name: name)
    result = @cookies.encrypted[name]
    #Rails.logger.debug{"PersistentUserStore get name: #{name}, value: #{result}"}
    result
  end
  
  def delete(name)
    name = cookie_name(name: name)
    @cookies.delete(name, DynamicCookieOptions.delete_cookie_options)
    Rails.logger.debug{"PersistentUserStore deleting cookie name: #{name}"}
  end
  
  def clear
    @cookies.each do |name, value|
      if name.start_with?(COOKIE_PREFIX)
        @cookies.delete(name, DynamicCookieOptions.delete_cookie_options)
      end
    end
  end
  
  def items
    @cookies
  end
  
  private
    def cookie_name(name:)
      if name.start_with?(COOKIE_PREFIX)
        name.to_sym
      else
        "#{COOKIE_PREFIX}_#{name}".to_sym
      end
    end
end
