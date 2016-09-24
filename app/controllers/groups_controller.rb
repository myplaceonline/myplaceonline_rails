class GroupsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:email_list, :missing_list]

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
  
  def missing_list
    set_obj
    
    @missing_contacts = Contact.where("identity_id = ? and id NOT IN (?)", User.current_user.primary_identity.id, @obj.all_contacts.map{|c| c.id})
    
  end
  
  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      value.blank?
    }
  end
  
  def self.param_names
    [
      :id,
      :group_name,
      :notes,
      group_contacts_attributes: [
        :id,
        :_destroy,
        contact_attributes: ContactsController.param_names
      ],
      group_references_attributes: [
        :id,
        :_destroy,
        group_attributes: [
          :id,
          :_destroy,
          :group_name,
          :notes,
          group_contacts_attributes: [
            :id,
            :_destroy,
            contact_attributes: ContactsController.param_names
          ]
        ]
      ]
    ]
  end

  def footer_items_show
    super + [
      {
        title: I18n.t('myplaceonline.groups.email_list'),
        link: groups_email_list_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t('myplaceonline.groups.missing'),
        link: groups_missing_list_path(@obj),
        icon: "search"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(groups.group_name) ASC"]
    end

    def obj_params
      params.require(:group).permit(GroupsController.param_names)
    end
end
