class JokesController < MyplaceonlineController
  protected
    def sorts
      ["lower(jokes.name) ASC"]
    end

    def obj_params
      params.require(:joke).permit(:name, :joke, :source)
    end
end
