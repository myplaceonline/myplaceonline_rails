class ConcertsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def sorts
      ["concerts.concert_date DESC"]
    end

    def insecure
      true
    end
    
    def obj_params
      params.require(:concert).permit(
        :concert_date,
        :concert_title,
        :notes,
        location_attributes: LocationsController.param_names,
        concert_musical_groups_attributes: [
          :id,
          :_destroy,
          musical_group_attributes: MusicalGroup.params
        ],
        concert_pictures_attributes: FilesController.multi_param_names
      )
    end
end
