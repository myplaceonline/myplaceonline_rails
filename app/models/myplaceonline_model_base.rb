class MyplaceonlineModelBase < ActiveRecord::Base
  self.abstract_class = true
  
  def self.build(params = nil)
    result = self.new(params)
    
    # If there's an encrypt attribute, then set the default
    # based on user preference, if available
    if result.respond_to?("encrypt")
      usr = User.current_user
      if !usr.nil?
        result.encrypt = usr.encrypt_by_default
      end
    end
    
    result
  end
end
