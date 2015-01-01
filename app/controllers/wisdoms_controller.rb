class WisdomsController < MyplaceonlineController
  def model
    Wisdom
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(wisdoms.name) ASC"]
    end

    def obj_params
      params.require(:wisdom).permit(:name, :wisdom)
    end
end
