class WebsiteDomainsController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.website_domains.domain_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(website_domains.domain_name)"]
    end

    def obj_params
      params.require(:website_domain).permit(
        :domain_name,
        :notes,
        :meta_description,
        :meta_keywords,
        :hosts,
        :static_homepage,
        :menu_links_static,
        :menu_links_logged_in,
        :new_user_welcome,
        :about,
        :mission_statement,
        :faq,
        :homepage_path,
        :feed_url,
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
        ],
        favicon_ico_identity_file_attributes: FilesController.param_names,
        favicon_png_identity_file_attributes: FilesController.param_names,
        default_header_icon_identity_file_attributes: FilesController.param_names,
      )
    end
end
