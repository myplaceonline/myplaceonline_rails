class AlertsDisplaysController < MyplaceonlineController
  
  def self.permit_params
    [
      :suppress_hotel
    ]
  end
  
  def showmyplet
    
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
