class PointDisplaysController < MyplaceonlineController
  protected
    def before_show
      if params[:myplet]
        @totalPoints = current_user.total_points
      end
    end
    
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
