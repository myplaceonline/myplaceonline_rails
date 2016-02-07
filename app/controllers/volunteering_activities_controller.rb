class VolunteeringActivitiesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(volunteering_activities.volunteering_activity_name) ASC"]
    end

    def obj_params
      params.require(:volunteering_activity).permit(
        :volunteering_activity_name,
        :notes
      )
    end
end
