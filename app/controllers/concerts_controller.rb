class ConcertsController < MyplaceonlineController
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
        Myp.select_or_create_permit(params[:concert], :location_attributes, LocationsController.param_names),
        concert_musical_groups_attributes: [
          :id,
          :_destroy,
          musical_group_attributes: MusicalGroup.params
        ]
      )
    end
end
