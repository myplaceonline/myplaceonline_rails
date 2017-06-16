class LifeGoalsController < MyplaceonlineController
  def show_search
    !@myplet
  end
  
  def show_favorites
    !@myplet
  end
  
  def show_additional
    !@myplet
  end
  
  def show_add_button
    false
  end
  
  protected
    def sorts
      ["life_goals.long_term ASC NULLS FIRST, lower(life_goals.life_goal_name) ASC"]
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

    def all_additional_sql(strict)
      if !strict && @myplet
        "and (long_term is null or long_term = false)"
      else
        nil
      end
    end
end
