class IdeasController < MyplaceonlineController
  def model
    Idea
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(ideas.name) ASC"]
    end

    def obj_params
      params.require(:idea).permit(:name, :idea)
    end
end
