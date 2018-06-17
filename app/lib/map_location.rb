class MapLocation
  def initialize(latitude:, longitude:, label: nil, tooltip: nil, popupHtml: nil, icon: nil, labelColor: nil)
    @latitude = latitude
    @longitude = longitude
    @label = label
    @tooltip = tooltip
    @popupHtml = popupHtml
    @icon = icon
    @labelColor = labelColor
  end
  
  def as_json(options={})
    
    final_icon = @icon
    if !@icon.blank? && !@icon.start_with?("http") && !@icon.start_with?("/")
      final_icon = ActionController::Base.helpers.image_path("google/#{final_icon}.png")
    end
    
    {
      position: {
        lat: @latitude.to_f,
        lng: @longitude.to_f
      },
      label: @label,
      tooltip: @tooltip,
      popupHtml: @popupHtml,
      iconUrl: final_icon,
      labelColor: @labelColor,
    }
  end
end
