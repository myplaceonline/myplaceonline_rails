class ContactsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def index
    @contact_type = params[:contact_type]
    if !@contact_type.blank?
      @contact_type = @contact_type.to_i
    end
    super
  end

  def self.param_names(include_website: true, recurse: true, include_company: true)
    [
      :id,
      :_destroy,
      :contact_type,
      conversations_attributes: [
        :id,
        :conversation,
        :conversation_date,
        :_destroy
      ],
      contact_identity_attributes: Identity.param_names(include_website: include_website, recurse: recurse, include_company: include_company)
    ]
  end

  def search_index_name
    Identity.table_name
  end
  
  def groups
    set_obj
    @groups = Group.where("identity_id = :identity_id and archived is null", identity_id: User.current_user.current_identity_id).order(:group_name)
    @contact_groups = GroupContact.where(identity_id: User.current_user.current_identity_id, contact_id: @obj.id).map{|g| g.group_id}
    
    if request.post?
      @groups.each do |group|
        is_in_group = !@contact_groups.index(group.id).nil?
        if params["group" + group.id.to_s].is_true?
          if is_in_group
            # Nothing to do, already in group
          else
            # Need to add to the group
            GroupContact.create!(
              identity_id: User.current_user.current_identity_id,
              group_id: group.id,
              contact_id: @obj.id
            )
          end
        else
          if is_in_group
            # Remove the contact from the group
            GroupContact.where(identity_id: User.current_user.current_identity_id, contact_id: @obj.id, group_id: group.id).take!.destroy!
          else
            # Nothing to do, already not in group
          end
        end
      end

      # Reset in case there were changes
      @contact_groups = GroupContact.where(identity_id: User.current_user.current_identity_id, contact_id: @obj.id).map{|g| g.group_id}
    end
  end
  
  def combine
    set_obj
    
    destination = params.dig(:contact, :contact, :id)
    if !destination.blank?
      destination_contact = Contact.where(identity: MyplaceonlineExecutionContext.identity, id: destination.to_i).take!
      if destination_contact.id != @obj.id
        ActiveRecord::Base.transaction do
          destination_contact.combine!(@obj)
          
          Connection.where(identity: MyplaceonlineExecutionContext.identity, contact: @obj).update_all(contact_id: destination_contact.id)
          
          @obj.archive!
        end
        
        redirect_to(index_path, flash: { notice: I18n.t("myplaceonline.contacts.combine_complete") })
      end
    end
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.contacts.me"),
        link: contact_path(current_user.current_identity.ensure_contact!),
        icon: "user"
      }
    ]
  end
  
  def footer_items_show
    result = []
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.contacts.add_conversation"),
        link: new_contact_conversation_path(@obj),
        icon: "comment"
      }
    end
    
    if !@obj.contact_identity.primary_location.nil?
      result << {
        title: I18n.t("myplaceonline.contacts.location"),
        link: @obj.contact_identity.primary_location.map_url(prefer_human_readable: true),
        icon: "location"
      }
    end

    result << {
      title: I18n.t("myplaceonline.contacts.groups"),
      link: contact_groups_path(@obj),
      icon: "user"
    }
    
    result = result + super
    
    result << {
      title: I18n.t("myplaceonline.contacts.conversations"),
      link: contact_conversations_path(@obj),
      icon: "phone"
    }
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.contacts.combine"),
        link: contact_combine_path(@obj),
        icon: "grid"
      }
    end
    
    result
  end
  
  def do_update_before_save
    Rails.logger.debug{"do_update_before_save: #{Myp.debug_print(@obj)}"}
    @obj.contact_identity.encrypt = current_user.encrypt_by_default
  end

  protected

    def sensitive
      true
    end
    
    def before_edit
      @obj.contact_identity.encrypt = @obj.contact_identity.ssn_encrypted?
    end

    def edit_prerespond
      @encrypt = current_user.encrypt_by_default
    end
    
    def build_new_model
      @encrypt = current_user.encrypt_by_default
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.identities.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(identities.name)"]
    end

    def obj_params
      params.require(:contact).permit(
        ContactsController.param_names
      )
    end

    def all_additional_sql(strict)
      result = super(strict)
      if !strict
        if !@contact_type.blank?
          result = Myp.appendstr(result, " and contact_type = " + @contact_type.to_s)
        end
        result
      end
      result
    end

    # Join because we're sorting by identity name
    def all_joins
      :contact_identity
    end
    
    def all_includes
      :contact_identity
    end
end
