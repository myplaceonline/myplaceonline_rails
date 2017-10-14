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
    def additional_sorts
      [
        [I18n.t("myplaceonline.life_goals.long_term"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["life_goals.long_term", "lower(life_goals.life_goal_name) ASC"]
    end

    def default_sorts_additions
      "nulls first"
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
        "and archived IS NULL and (long_term is null or long_term = false)"
      else
        nil
      end
    end
end
