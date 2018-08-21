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
      },
      {
        title: I18n.t("myplaceonline.quizzes.start"),
        link: quiz_start_path(@parent),
        icon: "navigation"
      },
    ]
  end
  
  def footer_items_show
    result = []
    
    result << {
      title: I18n.t("myplaceonline.quiz_items.back"),
      link: quiz_path(@obj.quiz),
      icon: "back"
    }
    
    if @obj.copyable?
      result << {
        title: I18n.t("myplaceonline.quiz_items.copy"),
        link: quiz_quiz_item_copy_path(@parent, @obj),
        icon: "tag"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.quizzes.start"),
      link: quiz_start_path(@obj.quiz),
      icon: "navigation"
    }
    
    result + super
  end
  
  def quiz_show
    set_obj
  end
  
  def copy
    set_obj
    
    copy_targets = @obj.copy_targets
    
    @quizzes = copy_targets.map{|quiz| [quiz.quiz_name, quiz.id]}
    @selected_quiz = nil
    if copy_targets.length == 1
      @selected_quiz = copy_targets[0].id
    end

    if request.post?
      target = params[:target]
      if !target.blank?
        target_quiz = Quiz.find(params[:target].to_i)
        if Ability.authorize(identity: User.current_user.domain_identity, subject: target_quiz, action: :edit, request: request)
          QuizItem.create!(
            identity_id: User.current_user.domain_identity,
            quiz: target_quiz,
            quiz_question: @obj.quiz_question,
            quiz_answer: @obj.quiz_answer,
            link: @obj.link,
            notes: @obj.notes,
          )
          redirect_to(
            quiz_start_path(@obj.quiz),
          )
        end
      end
    end
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
