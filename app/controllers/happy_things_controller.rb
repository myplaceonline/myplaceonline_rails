class HappyThingsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.happy_things.happy_thing_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(happy_things.happy_thing_name)"]
    end

    def obj_params
      params.require(:happy_thing).permit(
        :happy_thing_name,
        :notes
      )
    end
end
