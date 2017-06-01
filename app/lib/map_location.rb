class MapLocation
  def initialize(latitude:, longitude:, label: nil, tooltip: nil, popupHtml: nil)
    @latitude = latitude
    @longitude = longitude
    @label = label
    @tooltip = tooltip
    @popupHtml = popupHtml
  end
  
  def as_json(options={})
    {
      position: {
        lat: @latitude.to_f,
        lng: @longitude.to_f
      },
      label: @label,
      tooltip: @tooltip,
      popupHtml: @popupHtml
    }
  end
end
