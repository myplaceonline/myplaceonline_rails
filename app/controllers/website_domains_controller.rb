class WebsiteDomainsController < MyplaceonlineController
  protected
    def sorts
      ["lower(website_domains.domain_name) ASC"]
    end

    def obj_params
      params.require(:website_domain).permit(
        :domain_name,
        :notes,
        website_attributes: WebsitesController.param_names,
        domain_host_attributes: MembershipsController.param_names
      )
    end
end
