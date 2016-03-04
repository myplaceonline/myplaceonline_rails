class DraftsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(drafts.draft_name) ASC"]
    end

    def obj_params
      params.require(:draft).permit(
        :draft_name,
        :notes
      )
    end
end
