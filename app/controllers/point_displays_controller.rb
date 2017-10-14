class PointDisplaysController < MyplaceonlineController
  
  def showmyplet
    @totalPoints = current_user.total_points
  end
  
  protected
    def obj_params
      params.require(:point_display).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
