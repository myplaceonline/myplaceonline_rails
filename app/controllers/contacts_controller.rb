class ContactsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def index
    @contact_type = params[:contact_type]
    @hidden = params[:hidden]
    if !@contact_type.blank?
      @contact_type = @contact_type.to_i
    end
    if !@hidden.nil?
      @hidden = @hidden.to_bool
    else
      @hidden = false
    end
    super
  end

  def self.param_names(include_website: true, recurse: true)
    [
      :id,
      :_destroy,
      :contact_type,
      :hide,
      conversations_attributes: [
        :id,
        :conversation,
        :conversation_date,
        :_destroy
      ],
      contact_identity_attributes: [
        :id,
        :name,
        :middle_name,
        :last_name,
        :nickname,
        :birthday,
        :notes,
        :likes,
        :gift_ideas,
        :ktn,
        :sex_type,
        :new_years_resolution,
        identity_phones_attributes: [
          :id,
          :number,
          :phone_type,
          :_destroy
        ],
        identity_emails_attributes: [
          :id,
          :_destroy,
          :email,
          :secondary
        ],
        identity_locations_attributes: [
          :id,
          :_destroy,
          location_attributes: LocationsController.param_names(include_website: include_website)
        ],
        identity_drivers_licenses_attributes: [
          :id,
          :identifier,
          :expires,
          :region,
          :sub_region1,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :_destroy
          ]
        ],
        identity_relationships_attributes: [
          :id,
          :relationship_type,
          :_destroy,
          contact_attributes:
            recurse ?
              ContactsController.param_names(include_website: include_website, recurse: false) :
              [
                :id,
                :_destroy
              ]
        ],
        identity_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ],
        company_attributes: CompaniesController.param_names(include_website: include_website)
      ]
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "hide" }.all?{|key, value|
      if key == "contact_identity_attributes"
        value.all?{|key2, value2|
          if key2 == "company_attributes"
            CompaniesController.reject_if_blank(value2)
          else
            value2.blank?
          end
        }
      else
        value.blank?
      end
    }
  end

  def search_index_name
    Identity.table_name
  end
  
  def groups
    set_obj
    @groups = Group.where(identity_id: User.current_user.primary_identity.id).order(:group_name)
    @contact_groups = GroupContact.where(identity_id: User.current_user.primary_identity.id, contact_id: @obj.id).map{|g| g.group_id}
    
    if request.post?
      @groups.each do |group|
        is_in_group = !@contact_groups.index(group.id).nil?
        if params["group" + group.id.to_s]
          if is_in_group
            # Nothing to do, already in group
          else
            # Need to add to the group
            GroupContact.create(
              identity_id: User.current_user.primary_identity.id,
              group_id: group.id,
              contact_id: @obj.id
            )
          end
        else
          if is_in_group
            # Remove the contact from the group
            GroupContact.where(identity_id: User.current_user.primary_identity.id, contact_id: @obj.id, group_id: group.id).take!.destroy!
          else
            # Nothing to do, already not in group
          end
        end
      end

      # Reset in case there were changes
      @contact_groups = GroupContact.where(identity_id: User.current_user.primary_identity.id, contact_id: @obj.id).map{|g| g.group_id}
    end
  end
  
  protected

    def sorts
      ["lower(identities.name) ASC"]
    end

    def obj_params
      params.require(:contact).permit(
        ContactsController.param_names
      )
    end

    def all_additional_sql(strict)
      if strict
        nil
      else
        if @hidden
          result = ""
        else
          result = " and (hide is null or hide = false)"
        end
        if !@contact_type.blank?
          result = Myp.appendstr(result, " and contact_type = " + @contact_type.to_s)
        end
        result
      end
    end

    # Join because we're sorting by identity name
    def all_joins
      :contact_identity
    end
    
    def all_includes
      :contact_identity
    end
end
