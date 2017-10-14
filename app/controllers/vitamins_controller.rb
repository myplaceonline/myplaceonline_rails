class VitaminsController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.vitamins.vitamin_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(vitamins.vitamin_name)"]
    end

    def obj_params
      params.require(:vitamin).permit(Vitamin.params)
    end
    
    def has_category
      false
    end

    def before_all_actions
      @topedit = true
    end
    
    def filter_json_index_search()
      remove_ids = VitaminIngredient.where(identity_id: current_user.primary_identity.id).map{|vi| vi.vitamin_id}
      @objs = @objs.to_a.delete_if{|x| remove_ids.find_index(x.id) }
    end
end
