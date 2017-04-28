class LifeGoalsController < MyplaceonlineController
  protected
    def sorts
      ["lower(life_goals.life_goal_name) ASC"]
    end

    def obj_params
      params.require(:life_goal).permit(
        :life_goal_name,
        :notes,
        :position,
        :goal_started,
        :goal_ended,
        :long_term
      )
    end
end
