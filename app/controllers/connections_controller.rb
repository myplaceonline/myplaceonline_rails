class ConnectionsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["connections.updated_at DESC"]
    end

    def obj_params
      params.require(:connection).permit(
        user_attributes: [
          :id
        ]
      )
    end
end
