class FavoriteProductsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.favorite_products.product_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(favorite_products.product_name)"]
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
