class BarsController < MyplaceonlineController
  def may_upload
    true
  end

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:bar).permit(
        :notes,
        :rating,
        :rooftop,
        location_attributes: LocationsController.param_names,
        bar_pictures_attributes: FilesController.multi_param_names
      )
    end

    def show_map?
      true
    end
end
