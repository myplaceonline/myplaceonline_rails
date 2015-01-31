class MoviesController < MyplaceonlineController
  def model
    Movie
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(movies.name) ASC"]
    end

    def obj_params
      params.require(:movie).permit(:name, :url, :is_watched)
    end

    def create_presave
      update_watched
    end
    
    def update_presave
      update_watched
    end
    
    def update_watched
      if @obj.is_watched == "1"
        @obj.watched = Time.now
      else
        @obj.watched = nil
      end
    end

    def before_edit
      @obj.is_watched = !@obj.watched.nil?
    end
end
