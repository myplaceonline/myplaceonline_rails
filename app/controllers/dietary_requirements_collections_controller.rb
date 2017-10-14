class DietaryRequirementsCollectionsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.dietary_requirements_collections.dietary_requirements_collection_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(dietary_requirements_collections.dietary_requirements_collection_name)"]
    end

    def obj_params
      params.require(:dietary_requirements_collection).permit(
        DietaryRequirementsCollection.param_names
      )
    end
end
