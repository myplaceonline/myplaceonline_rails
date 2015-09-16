class NotepadsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(notepads.title) ASC"]
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
