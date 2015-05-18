class ExercisesController < MyplaceonlineController
  def model
    Exercise
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def insecure
      true
    end

    def sorts
      ["exercises.exercise_start DESC"]
    end

    def obj_params
      params.require(:exercise).permit(:exercise_start, :exercise_end, :exercise_activity, :notes, :situps, :pushups)
    end
    
    def new_obj_initialize
      @obj.exercise_start = DateTime.now
    end
end
