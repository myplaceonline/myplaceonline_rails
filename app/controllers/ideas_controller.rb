class IdeasController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(ideas.name) ASC"]
    end

    def obj_params
      params.require(:idea).permit(:name, :idea)
    end
end
