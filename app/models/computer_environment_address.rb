class ComputerEnvironmentAddress < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :host_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :ip_address, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  belongs_to :computer_environment

  validates :host_name, presence: true

  def display
    Myp.appendstr(self.host_name, self.ip_address, nil, " (", ")")
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :host_name,
      :ip_address,
    ]
  end
end
