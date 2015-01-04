class FeedsController < MyplaceonlineController
  def model
    Feed
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(feeds.name) ASC"]
    end

    def obj_params
      params.require(:feed).permit(:name, :url)
    end
end
