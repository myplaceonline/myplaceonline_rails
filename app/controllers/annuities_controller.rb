class AnnuitiesController < MyplaceonlineController
  protected
    def sorts
      ["lower(annuities.annuity_name) ASC"]
    end

    def obj_params
      params.require(:annuity).permit(
        :annuity_name,
        :notes
      )
    end
end
