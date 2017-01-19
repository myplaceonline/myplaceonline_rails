class PasswordShare < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :password, required: true)

  child_property(name: :user, required: true)
  
  child_properties(name: :password_secret_shares)

  def display
    password.display + ":" + user.display
  end
  
  def permission_action(action)
    action == :transfer ? Permission::ACTION_READ : Permission::ACTION_UPDATE
  end
end
