class CreditReportsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.credit_report_date.year.to_s
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.credit_reports.credit_report_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["credit_reports.credit_report_date"]
    end

    def obj_params
      params.require(:credit_report).permit(
        :credit_report_date,
        :credit_reporting_agency,
        :credit_report_description,
        :annual_free_report,
        :notes,
        credit_report_files_attributes: FilesController.multi_param_names,
      )
    end
end
