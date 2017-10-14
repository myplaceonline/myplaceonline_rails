class ExercisesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.exercises.exercise_start"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["exercises.exercise_start"]
    end

    def obj_params
      params.require(:exercise).permit(
        :exercise_start,
        :exercise_end,
        :exercise_activity,
        :notes,
        :situps,
        :pushups,
        :cardio_time
      )
    end
end
