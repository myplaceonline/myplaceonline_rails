class VitaminsController < MyplaceonlineController
  def model
    Vitamin
  end

  def display_obj(obj)
    obj.display
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
end
