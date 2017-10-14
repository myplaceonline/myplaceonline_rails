class DesiredProductsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.desired_products.product_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(desired_products.product_name)"]
    end

    def obj_params
      params.require(:desired_product).permit(
        :product_name,
        :notes
      )
    end
end
