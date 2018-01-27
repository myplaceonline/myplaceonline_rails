class ComputerEnvironmentPassword < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  belongs_to :computer_environment
  
  child_property(name: :password, required: true)
  
  def display
    self.password.display
  end
  
  def self.params
    [
      :id,
      :_destroy,
      password_attributes: PasswordsController.param_names + [:id]
    ]
  end
end
