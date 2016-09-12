class WebsiteListsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(website_lists.website_list_name) ASC"]
    end

    def obj_params
      params.require(:website_list).permit(
        :website_list_name,
        :notes,
        website_list_items_attributes: [
          :id,
          :_destroy,
          :position,
          website_attributes: WebsitesController.param_names
        ]
      )
    end
end
