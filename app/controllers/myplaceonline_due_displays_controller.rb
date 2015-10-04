class MyplaceonlineDueDisplaysController < MyplaceonlineController
  def showmyplet
    @due = DueItem.all_due(current_user)
  end
  
  protected
    def sorts
      ["myplaceonline_due_displays.updated_at DESC"]
    end

    def obj_params
      params.require(:myplaceonline_due_display).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
