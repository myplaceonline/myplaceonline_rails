class BoycottsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.boycotts.boycott_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(boycotts.boycott_name)"]
    end

    def obj_params
      params.require(:boycott).permit(
        :boycott_name,
        :boycott_start,
        :notes,
        boycott_files_attributes: FilesController.multi_param_names
      )
    end
end
