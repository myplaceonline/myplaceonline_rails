class BookStoresController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["book_stores.updated_at DESC"]
    end

    def obj_params
      params.require(:book_store).permit(
        :rating,
        location_attributes: LocationsController.param_names
      )
    end
end
