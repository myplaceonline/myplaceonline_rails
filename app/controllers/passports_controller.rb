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
    def all
      if @expired.blank? || !@expired
        model.where("owner_id = ? and (expires is null or expires > now())", current_user.primary_identity)
      else
        model.where(
          owner_id: current_user.primary_identity.id
        )
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
