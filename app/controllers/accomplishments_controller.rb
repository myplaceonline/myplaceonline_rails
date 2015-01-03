class AccomplishmentsController < MyplaceonlineController
  def model
    Accomplishment
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["accomplishments.updated_at DESC"]
    end

    def obj_params
      params.require(:accomplishment).permit(:name, :accomplishment)
    end
end
