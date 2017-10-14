class ExerciseRegimensController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.exercise_regimens.exercise_regimen_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(exercise_regimens.exercise_regimen_name)"]
    end

    def obj_params
      params.require(:exercise_regimen).permit(
        :exercise_regimen_name,
        :notes,
        exercise_regimen_exercises_attributes: [
          :id,
          :_destroy,
          :exercise_regimen_exercise_name,
          :position,
          :notes,
          exercise_regimen_exercise_files_attributes: FilesController.multi_param_names
        ]
      )
    end
end
