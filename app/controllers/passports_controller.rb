class PassportsController < MyplaceonlineController
  def may_upload
    true
  end

  def index
    @expired = params[:expired]
    if !@expired.blank?
      @expired = @expired.to_bool
    end
    super
  end

  protected
    def all_additional_sql
      if @expired.blank? || !@expired
        "and (expires is null or expires > now())"
      else
        nil
      end
    end

    def sorts
      ["lower(passports.region) ASC"]
    end

    def obj_params
      params.require(:passport).permit(
        :region,
        :passport_number,
        :expires,
        :issued,
        :issuing_authority,
        :name,
        passport_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end
end
