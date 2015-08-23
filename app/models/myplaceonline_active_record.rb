class MyplaceonlineActiveRecord < ActiveRecord::Base
  self.abstract_class = true
  
  belongs_to :owner, class_name: Identity

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    if self.respond_to?("owner=")
      current_user = User.current_user
      if !current_user.nil?
        if !self.owner.nil?
          if self.owner_id != current_user.primary_identity.id
            raise "Unauthorized"
          end
        else
          self.owner = current_user.primary_identity
        end
      else
        raise "User.current_user not set"
      end
    else
      raise "owner= not found"
    end
  end
end
