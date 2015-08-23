class MyplaceonlineModelBase < ActiveRecord::Base
  self.abstract_class = true
  
  def self.build(params = nil)
    
    # We don't actually pass in params to new because that will cause
    # a ForbiddenAttributesError. They may be set separately using
    # assign_attributes. The params are just passed in so that the model
    # has a chance to access form values
    
    result = self.new
    
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
