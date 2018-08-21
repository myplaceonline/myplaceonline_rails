class QuizzesController < MyplaceonlineController
  def footer_items_show
    result = []
    
    result << {
      title: I18n.t("myplaceonline.quizzes.start"),
      link: quiz_start_path(@obj),
      icon: "navigation"
    }
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.quizzes.add_quiz_item"),
        link: new_quiz_quiz_item_path(@obj),
        icon: "plus"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.quizzes.quiz_items"),
      link: quiz_quiz_items_path(@obj),
      icon: "bars"
    }
    
    result + super
  end
  
  def start
    set_obj
    
    redirect_to(quiz_quiz_item_quiz_show_path(@obj, @obj.next_random_question))
  end

  def data_split_icon
    "navigation"
  end
  
  def split_link(obj)
    ActionController::Base.helpers.link_to(
      I18n.t("myplaceonline.quizzes.start"),
      quiz_start_path(obj)
    )
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
        [I18n.t("myplaceonline.quizzes.quiz_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["quizzes.quiz_name"]
    end

    def obj_params
      params.require(:quiz).permit(
        :quiz_name,
        :notes,
      )
    end
end
