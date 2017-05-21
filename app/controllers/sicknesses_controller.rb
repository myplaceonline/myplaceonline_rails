class SicknessesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      #["lower(test_objects.test_object_name) ASC"]
      ["sicknesses.sickness_start DESC NULLS LAST"]
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
