class PassportsController < MyplaceonlineController
  def model
    Passport
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
