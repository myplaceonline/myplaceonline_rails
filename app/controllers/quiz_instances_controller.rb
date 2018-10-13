class QuizInstancesController < MyplaceonlineController
  def may_upload
    true
  end

  def path_name
    "quiz_quiz_instance"
  end

  def form_path
    "quiz_instances/form"
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
    ]
  end
  
  def footer_items_show
    result = []
    
    result << {
      title: I18n.t("myplaceonline.quiz_items.back"),
      link: quiz_path(@obj.quiz),
      icon: "back"
    }
    
    if !MyplaceonlineExecutionContext.offline?
      if @obj.end_time.nil?
        result << {
          title: I18n.t("myplaceonline.quiz_instances.go"),
          link: quiz_quiz_instance_go_path(@obj.quiz, @obj),
          icon: "navigation"
        }
      else
        result << {
          title: I18n.t("myplaceonline.quiz_instances.restart"),
          link: quiz_quiz_instance_restart_path(@obj.quiz, @obj),
          icon: "navigation"
        }
      end
    end
    
    result + super
  end
  
  def go
    set_obj
    
    sorted_questions = @obj.quiz.quiz_items
    
    if @obj.last_question.nil?
      @question = sorted_questions[0]
      
      # The instance has "really" started now on the first question
      @obj.start_time = User.current_user.time_now
      @obj.save!
    else
      
      # Find the previous question
      last_question_index = sorted_questions.index{|check| check.id == @obj.last_question.id}
      
      Rails.logger.debug{"Last question index: #{last_question_index}"}
      
      # Get the next question
      @question = sorted_questions[last_question_index + 1]
    end
    
    Rails.logger.debug{"Last question: #{@obj.last_question}, current question: #{@question}"}
    
    @choice = params[:choice]
    
    if !@choice.blank?
      
      @obj.last_question = @question
      @obj.save!
      
      if @choice == @question.correct_choice.to_s
        if @obj.correct.nil?
          @obj.correct = 0
        end
        @obj.correct = @obj.correct + 1
        @obj.save!
      end
      
      # Check if there are no more questions
      last_question_index = sorted_questions.index{|check| check.id == @question.id}
      
      if last_question_index == sorted_questions.length - 1
        # Completed!
        @obj.end_time = User.current_user.time_now
        @obj.save!
        
        redirect_to_obj
      else
        # Go to the next question
        redirect_to(quiz_quiz_instance_go_path(@obj.quiz, @obj))
      end
    end
  end
  
  def restart
    set_obj
    
    @obj.last_question = nil
    @obj.correct = nil
    @obj.end_time = nil
    @obj.save!
    
    redirect_to(quiz_quiz_instance_go_path(@obj.quiz, @obj))
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
      ]
    end

    def default_sort_columns
      ["quiz_instances.start_time"]
    end
    
    def default_sort_direction
      "desc"
    end

    def obj_params
      params.require(:quiz_instance).permit(QuizInstance.params)
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
