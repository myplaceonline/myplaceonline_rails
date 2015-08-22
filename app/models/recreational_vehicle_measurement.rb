class RecreationalVehicleMeasurement < MyplaceonlineActiveRecord
  belongs_to :recreational_vehicle

  validates :measurement_name, presence: true
  
  def display
    measurement_name
  end
end
