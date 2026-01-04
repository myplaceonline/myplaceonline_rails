class WebsiteDomainsController < MyplaceonlineController
  def footer_items_show
    if @obj.verified?
      super + [
        {
          title: I18n.t("myplaceonline.website_domains.update_myplets"),
          link: website_domain_update_myplets_path(@obj),
          icon: "recycle"
        },
      ]
    else
      super
    end
  end
  
  def update_myplets
    set_obj
    
    if !@obj.verified?
      raise "Unauthorized"
    end
    
    ApplicationJob.perform(UpdateMypletsJob, @obj)
    
    redirect_to(
      obj_path,
      flash: { notice: I18n.t("myplaceonline.website_domains.updating_myplets") }
    )
  end
  
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
        :only_homepage,
        :ajax_config,
        :confirm_redirect,
        :url_mappings_json,
        :email_name_override,
        :email_host_override,
        :email_display_override,
        :secondary_email_name,
        :skipterms,
        :allow_public,
        :handlesubdomains,
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
        website_domain_myplets_attributes: WebsiteDomainMyplet.params,
        website_domain_properties_attributes: WebsiteDomainProperty.params,
        mailing_list_attributes: GroupsController.param_names,
      )
    end
end
