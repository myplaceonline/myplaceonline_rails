class BookStoresController < MyplaceonlineController
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
      params.require(:book_store).permit(
        :rating,
        location_attributes: LocationsController.param_names
      )
    end
end
