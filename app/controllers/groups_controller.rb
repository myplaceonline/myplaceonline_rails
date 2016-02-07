class GroupsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:email_list]

  def email_list
    set_obj
    
    @found_emails = true
    @emails = @obj.group_contacts.map{ |x|
      x.contact.contact_identity.identity_emails.length == 0 ? nil : x.contact.contact_identity.identity_emails.map{ |ie| ie.email }.join(", ")
    }.reject{ |x| x.nil? }.join(", ")
    @no_emails = @obj.group_contacts.map{ |x|
      x.contact.contact_identity.identity_emails.length == 0 ? ActionController::Base.helpers.link_to(ActionController::Base.helpers.escape_once(x.contact.display), contact_path(x.contact)) : nil
    }.reject{ |x| x.nil? }.join(", ")
    
    if @emails.blank?
      @emails = I18n.t("myplaceonline.groups.no_emails")
      @found_emails = false
    end
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(groups.group_name) ASC"]
    end

    def obj_params
      params.require(:group).permit(
        :group_name,
        :notes,
        group_contacts_attributes: [
          :id,
          :_destroy,
          contact_attributes: ContactsController.param_names
        ]
      )
    end
end
