class GroupsController < MyplaceonlineController
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
    
    existing_contacts = @obj.all_contacts.map{|c| c.id}
    
    if existing_contacts.size == 0
      existing_contacts = [-1]
    end
    
    @missing_contacts = Contact.joins(:contact_identity).includes(:contact_identity).where(
      "contacts.identity_id = ? and contacts.id NOT IN (?) and contacts.archived IS NULL",
      User.current_user.current_identity_id,
      existing_contacts
    ).order(Identity.order)
    
    if request.post?
      
      contacts_added = 0
      
      params.each do |key, value|
        if key.start_with?("contact_") && value.is_true?
          contact_id = key[8..-1].to_i
          contact = Contact.where(id: contact_id, identity_id: User.current_user.current_identity_id).take!
          GroupContact.create!(
            identity_id: User.current_user.current_identity_id,
            group_id: @obj.id,
            contact_id: contact.id
          )
          contacts_added = contacts_added + 1
        end
      end
      
      if contacts_added > 0
        redirect_to(group_path(@obj), notice: I18n.t("myplaceonline.groups.added_contacts", count: contacts_added))
      end
    end
    
  end
  
  def empty
    set_obj
    
    if request.post?
      
      @obj.group_contacts.destroy_all
      @obj.group_references.destroy_all
      
      redirect_to(group_path(@obj), notice: I18n.t("myplaceonline.groups.emptied"))
    else
      @count = @obj.all_contacts.count
    end
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
        title: I18n.t("myplaceonline.groups.email_list"),
        link: group_email_list_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.groups.missing"),
        link: group_missing_list_path(@obj),
        icon: "search"
      },
      {
        title: I18n.t("myplaceonline.groups.empty"),
        link: group_empty_path(@obj),
        icon: "forbidden"
      },
    ]
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.groups.group_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(groups.group_name)"]
    end

    def obj_params
      params.require(:group).permit(GroupsController.param_names)
    end
end
