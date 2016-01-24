class ActivitiesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(activities.name) ASC"]
    end

    def obj_params
      params.require(:activity).permit(:name, :notes)
    end
end
