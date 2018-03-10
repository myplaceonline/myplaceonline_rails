class ConcertsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.concerts.concert_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["concerts.concert_date"]
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

    def show_map?
      true
    end
end
