class HaircutsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    result = nil
    if !obj.cutter.nil?
      result = Myp.appendstr(result, obj.cutter.display, " - ")
    end
    if !obj.location.nil?
      result = Myp.appendstr(result, obj.location.display_really_simple, " - ")
    end
    return result
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.haircuts.haircut_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["haircuts.haircut_time"]
    end

    def obj_params
      params.require(:haircut).permit(
        :haircut_time,
        :total_cost,
        :notes,
        haircut_files_attributes: FilesController.multi_param_names,
        cutter_attributes: ContactsController.param_names,
        location_attributes: LocationsController.param_names,
      )
    end
end
