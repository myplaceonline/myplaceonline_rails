class SicknessesController < MyplaceonlineController
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
        [I18n.t("myplaceonline.sicknesses.sickness_start"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["sicknesses.sickness_start"]
    end

    def obj_params
      params.require(:sickness).permit(
        :sickness_start,
        :sickness_end,
        :coughing,
        :sneezing,
        :throwing_up,
        :fever,
        :runny_nose,
        :notes,
        sickness_files_attributes: FilesController.multi_param_names
      )
    end
end
