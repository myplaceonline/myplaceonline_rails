class Computer < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :computer_model, presence: true
  
  def display
    result = nil
    if !manufacturer.nil?
      result = Myp.appendstr(result, manufacturer.display)
    end
    result = Myp.appendstr(result, computer_model)
    result
  end
  
  child_property(name: :manufacturer, model: Company)

  child_property(name: :administrator, model: Password)
  
  child_property(name: :main_user, model: Password)

  child_properties(name: :computer_ssh_keys)

  def self.skip_check_attributes
    ["hyperthreaded"]
  end
end
