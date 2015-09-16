class WisdomsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(wisdoms.name) ASC"]
    end

    def obj_params
      params.require(:wisdom).permit(
        :name,
        :wisdom
      )
    end
end
