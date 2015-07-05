class VitaminsController < MyplaceonlineController
  def model
    Vitamin
  end

  protected
    def sorts
      ["lower(vitamins.vitamin_name) ASC"]
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
      remove_ids = VitaminIngredient.where(owner_id: current_user.primary_identity.id).map{|vi| vi.vitamin_id}
      @objs = @objs.to_a.delete_if{|x| remove_ids.find_index(x.id) }
    end
end
