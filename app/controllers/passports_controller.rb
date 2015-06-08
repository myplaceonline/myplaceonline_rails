class PassportsController < MyplaceonlineController
  def model
    Passport
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["lower(passports.region) ASC"]
    end

    def obj_params
      params.require(:passport).permit(
        :region,
        :passport_number,
        :expires,
        :issued
      )
    end
end
