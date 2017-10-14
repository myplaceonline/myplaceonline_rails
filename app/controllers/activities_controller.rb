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

    def default_sort_columns
      ["lower(#{model.table_name}.name)"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.activities.name"), default_sort_columns[0]]
      ]
    end

    def obj_params
      params.require(:activity).permit(:name, :notes)
    end
end
