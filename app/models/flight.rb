class Flight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :flight_name, presence: true
  
  def display
    flight_name
  end
end
