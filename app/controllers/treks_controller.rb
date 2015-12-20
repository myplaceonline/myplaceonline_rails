class TreksController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["treks.updated_at DESC"]
    end

    def obj_params
      params.require(:trek).permit(
        :notes,
        :rating,
        Myp.select_or_create_permit(params[:trek], :location_attributes, LocationsController.param_names),
        trek_pictures_attributes: [
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
