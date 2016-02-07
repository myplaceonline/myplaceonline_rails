class BarsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["bars.updated_at DESC"]
    end

    def obj_params
      params.require(:bar).permit(
        :notes,
        :rating,
        location_attributes: LocationsController.param_names,
        bar_pictures_attributes: [
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
