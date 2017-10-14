class ReceiptsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.receipts.receipt_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["receipts.receipt_time"]
    end

    def obj_params
      params.require(:receipt).permit(
        :receipt_name,
        :receipt_time,
        :amount,
        :notes,
        receipt_files_attributes: FilesController.multi_param_names
      )
    end
end
