class BillsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.bill_date.to_s
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.bills.bill_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["bills.bill_date", "lower(bills.bill_name) ASC"]
    end

    def default_sort_direction
      "desc"
    end

    def obj_params
      params.require(:bill).permit(
        :bill_name,
        :bill_date,
        :amount,
        :notes,
        bill_files_attributes: FilesController.multi_param_names
      )
    end
end
