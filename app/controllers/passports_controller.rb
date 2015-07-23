class PassportsController < MyplaceonlineController
  def model
    Passport
  end

  def may_upload
    true
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
        :issued,
        :issuing_authority,
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

    def presave
      @obj.passport_pictures.each do |pic|
        if pic.identity_file.folder.nil?
          pic.identity_file.folder = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.passports"), @obj.display])
        end
      end
    end
end
