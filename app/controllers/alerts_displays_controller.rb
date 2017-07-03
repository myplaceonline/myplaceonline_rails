class AlertsDisplaysController < MyplaceonlineController
  
  def self.permit_params
    [
      :suppress_hotel
    ]
  end
  
  def showmyplet
    @nocontent = true
    now = User.current_user.time_now
    @trip = Trip.where(
      %{
        identity_id = ? AND
        started IS NOT NULL AND
        ended IS NOT NULL AND
        ? >= started AND
        ? <= ended AND
        (explicitly_completed IS NULL OR explicitly_completed = ?)
      },
      User.current_user.current_identity_id,
      now,
      now,
      false
    ).order("started desc").first
    if !@trip.nil?
      @next_trip_flight = @trip.next_trip_flight
      @nocontent = false
    end
  end
  
  protected
    def sorts
      ["alerts_displays.updated_at DESC"]
    end

    def obj_params
      params.require(:alerts_display).permit(
        AlertsDisplaysController.permit_params
      )
    end

    def has_category
      false
    end
end
