class PublicSearchesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:public_search).permit(
        :category
      )
    end
end
