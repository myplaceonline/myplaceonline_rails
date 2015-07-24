class WarrantiesController < MyplaceonlineController
  def model
    Warranty
  end
  
  protected
    def sorts
      ["lower(warranties.warranty_name) ASC"]
    end

    def obj_params
      params.require(:warranty).permit(Warranty.params)
    end
    
    def has_category
      false
    end
end
