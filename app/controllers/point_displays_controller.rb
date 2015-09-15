class PointDisplaysController < MyplaceonlineController
  
  def showmyplet
    @totalPoints = current_user.total_points
    super
  end
  
  protected
    def sorts
      ["point_displays.updated_at DESC"]
    end

    def obj_params
      params.require(:point_display).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
