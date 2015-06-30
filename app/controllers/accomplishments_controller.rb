class AccomplishmentsController < MyplaceonlineController
  def model
    Accomplishment
  end

  protected
    def sorts
      ["accomplishments.updated_at DESC"]
    end

    def obj_params
      params.require(:accomplishment).permit(:name, :accomplishment)
    end
end
