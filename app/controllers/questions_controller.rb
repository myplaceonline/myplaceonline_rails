class QuestionsController < MyplaceonlineController
  def model
    Question
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(questions.name) ASC"]
    end

    def obj_params
      params.require(:question).permit(:name, :notes)
    end
end
