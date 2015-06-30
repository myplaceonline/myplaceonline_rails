class ActivitiesController < MyplaceonlineController
  def model
    Activity
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(activities.name) ASC"]
    end

    def obj_params
      params.require(:activity).permit(:name)
    end
end
