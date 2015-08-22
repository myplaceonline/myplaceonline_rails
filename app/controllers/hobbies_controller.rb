class HobbiesController < MyplaceonlineController
  def model
    Hobby
  end

  protected
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
