class ExercisesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["exercises.exercise_start DESC"]
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
