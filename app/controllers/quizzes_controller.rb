class QuizzesController < MyplaceonlineController
  def footer_items_show
    result = []
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.quizzes.start"),
        link: quiz_start_path(@obj),
        icon: "navigation"
      }

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
    
    if !@obj.autolink.blank? && !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.quizzes.autogenerate"),
        link: quiz_autogenerate_path(@obj),
        icon: "cloud"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.quizzes.quiz_instances"),
      link: quiz_quiz_instances_path(@obj),
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
  
  def autogenerate
    set_obj

    autogen_results = @obj.autogenerate
    
    redirect_to(
      obj_path,
      flash: {
        notice: I18n.t(
          "myplaceonline.quizzes.autogenerated",
          new_items: autogen_results[:new_items],
          old_items: autogen_results[:old_items],
        )
      }
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
        :autolink,
        :autogenerate_context,
        :choices,
      )
    end
end