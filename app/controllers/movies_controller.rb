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
      params.require(:movie).permit(:name, :url)
    end

    def create_presave
      update_watched
    end
    
    def update_presave
      update_watched
    end
    
    def update_watched
      if params[:watched] == "true"
        @obj.watched = Time.now
      else
        @obj.watched = nil
      end
    end
end
