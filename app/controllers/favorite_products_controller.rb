class FavoriteProductsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(favorite_products.product_name) ASC"]
    end

    def obj_params
      params.require(:favorite_product).permit(
        :product_name,
        :notes,
        favorite_product_links_attributes: [:id, :_destroy, :link],
        favorite_product_files_attributes: FilesController.multi_param_names
      )
    end
end
