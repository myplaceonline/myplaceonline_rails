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
        Myp.select_or_create_permit(params[:book_store], :location_attributes, LocationsController.param_names)
      )
    end
end
