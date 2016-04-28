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
        domain_host_attributes: MembershipsController.param_names,
        website_domain_ssh_keys_attributes: [
          :id,
          :_destroy,
          :username,
          ssh_key_attributes: SshKeysController.param_names
        ],
        website_domain_registrations_attributes: [
          :id,
          :_destroy,
          repeat_attributes: Repeat.params,
          periodic_payment_attributes: PeriodicPaymentsController.param_names
        ]
      )
    end
end
