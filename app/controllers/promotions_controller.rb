class PromotionsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.promotions.expires"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["promotions.expires", "lower(promotions.promotion_name) ASC"]
    end

    def obj_params
      params.require(:promotion).permit(
        :promotion_name,
        :started,
        :expires,
        :promotion_amount,
        :notes,
        promotion_files_attributes: FilesController.multi_param_names
      )
    end
end
