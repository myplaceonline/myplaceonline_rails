class NotepadsController < MyplaceonlineController
  protected
    def insecure
      true
    end
    
    def default_sort_columns
      ["lower(notepads.title)"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.notepads.title"), default_sort_columns[0]]
      ]
    end

    def obj_params
      params.require(:notepad).permit(
        :title,
        :notepad_data
      )
    end
    
    def update_security
    end
end
