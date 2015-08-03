class FavoriteProductsController < MyplaceonlineController
  def model
    FavoriteProduct
  end

  protected
    def sorts
      ["lower(favorite_products.product_name) ASC"]
    end

    def obj_params
      params.require(:favorite_product).permit(
        :product_name,
        :notes
      )
    end
end
