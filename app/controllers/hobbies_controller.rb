class HobbiesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(hobbies.hobby_name) ASC"]
    end

    def obj_params
      params.require(:hobby).permit(
        :hobby_name,
        :notes
      )
    end
end
