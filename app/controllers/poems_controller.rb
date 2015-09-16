class PoemsController < MyplaceonlineController
  protected
    def insecure
      true
    end

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
