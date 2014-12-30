class MoviesController < MyplaceonlineController
  protected
    def model
      Movie
    end

    def sorts
      ["lower(movies.name) ASC"]
    end

    def display_obj(obj)
      obj.name
    end

    def obj_params
      params.require(:movie).permit(:name, :watched, :url)
    end
end
