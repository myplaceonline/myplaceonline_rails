class DesiredProductsController < MyplaceonlineController
  def model
    DesiredProduct
  end

  protected
    def sorts
      ["lower(desired_products.product_name) ASC"]
    end

    def obj_params
      params.require(:desired_product).permit(
        :product_name,
        :notes
      )
    end
end
