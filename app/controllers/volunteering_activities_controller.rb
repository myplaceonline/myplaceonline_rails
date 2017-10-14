class VolunteeringActivitiesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.volunteering_activities.volunteering_activity_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(volunteering_activities.volunteering_activity_name)"]
    end

    def obj_params
      params.require(:volunteering_activity).permit(
        :volunteering_activity_name,
        :notes
      )
    end
end
