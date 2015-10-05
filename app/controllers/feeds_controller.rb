class FeedsController < MyplaceonlineController
  protected
    def sorts
      ["lower(feeds.name) ASC"]
    end

    def obj_params
      params.require(:feed).permit(:name, :url)
    end

    def insecure
      true
    end
end
