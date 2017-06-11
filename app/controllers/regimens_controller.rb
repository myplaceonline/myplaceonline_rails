class RegimensController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(regimens.regimen_name) ASC"]
    end

    def obj_params
      params.require(:regimen).permit(
        :regimen_name,
        :notes,
        regimen_items_attributes: RegimenItem.params,
      )
    end
end
