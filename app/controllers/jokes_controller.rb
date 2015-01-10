class JokesController < MyplaceonlineController
  def model
    Joke
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(jokes.name) ASC"]
    end

    def obj_params
      params.require(:joke).permit(:name, :joke)
    end
end
