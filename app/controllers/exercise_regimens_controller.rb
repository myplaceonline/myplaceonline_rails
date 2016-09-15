class ExerciseRegimensController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(exercise_regimens.exercise_regimen_name) ASC"]
    end

    def obj_params
      params.require(:exercise_regimen).permit(
        :exercise_regimen_name,
        :notes
      )
    end
end
