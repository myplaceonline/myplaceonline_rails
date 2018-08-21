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
      },
      {
        title: I18n.t("myplaceonline.quiz_items.copy"),
        link: quiz_quiz_item_copy_path(@parent, @obj),
        icon: "tag"
      }
    ] + super
  end
  
  def quiz_show
    set_obj
  end
  
  def copy
    set_obj
    
    @options = Quiz.where("identity_id = :identity_id and archived is null", identity_id: @obj.identity_id)
                   .dup.to_a
                   .delete_if{|quiz| quiz.id == @obj.quiz.id}
                   .map{|quiz| [quiz.quiz_name, quiz.id]}

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
