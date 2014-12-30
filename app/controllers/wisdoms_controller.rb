class WisdomsController < MyplaceonlineController
  protected
    def model
      Wisdom
    end

    def sorts
      ["lower(wisdoms.name) ASC"]
    end

    def display_obj(obj)
      obj.name
    end

    def obj_params
      params.require(:wisdom).permit(:name, :wisdom)
    end
end
