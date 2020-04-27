class FinancialAssetsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:totals]

  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_currency(obj.asset_value)
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.financial_assets.final_total"),
        link: financial_assets_totals_path,
        icon: "info"
      },
    ]
  end
  
  def totals
    total = 0
    @breakdown = {}
    self.all.order("asset_location ASC").each do |asset|
      if !asset.archived?
        total = total + asset.asset_value
        loc = asset.asset_location
        if loc.blank?
          loc = I18n.t("myplaceonline.financial_assets.no_location")
        end
        items = @breakdown[loc]
        if items.nil?
          items = []
        end
        items << asset
        @breakdown[loc] = items
      end
    end
    @total = total
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.financial_assets.asset_value"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["financial_assets.asset_value"]
    end

    def obj_params
      params.require(:financial_asset).permit(
        :asset_name,
        :asset_value,
        :asset_location,
        :asset_received,
        :notes,
        financial_asset_files_attributes: FilesController.multi_param_names,
      )
    end

    def sensitive
      true
    end
end
