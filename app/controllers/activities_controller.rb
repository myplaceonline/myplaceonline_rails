class ActivitiesController < MyplaceonlineController
  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.random.activity'),
        link: random_activity_path(:filter_activities => "1"),
        icon: "search"
      }
    ]
  end
  
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
