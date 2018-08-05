class QuizItemsController < MyplaceonlineController
  def path_name
    "quiz_quiz_item"
  end

  def form_path
    "quiz_items/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.quiz_items.back"),
        link: quiz_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.quiz_items.back"),
        link: quiz_path(@obj.quiz),
        icon: "back"
      }
    ] + super
  end
  
  def quiz_show
    set_obj
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.quiz_items.quiz_question"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(quiz_items.quiz_question)"]
    end

    def obj_params
      params.require(:quiz_item).permit(QuizItem.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Quiz
    end
end
