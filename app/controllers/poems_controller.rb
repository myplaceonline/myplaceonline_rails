class PoemsController < MyplaceonlineController
  def model
    Poem
  end

  protected
    def sorts
      ["lower(poems.poem_name) ASC"]
    end

    def obj_params
      params.require(:poem).permit(
        :poem_name,
        :poem
      )
    end
end
