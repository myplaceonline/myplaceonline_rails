class MapLocation
  def initialize(latitude:, longitude:, label: nil)
    @latitude = latitude
    @longitude = longitude
    @label = label
  end
  
  def as_json(options={})
    {
      position: {
        lat: @latitude.to_f,
        lng: @longitude.to_f
      },
      label: @label
    }
  end
end
