class ContactsController < MyplaceonlineController
  def model
    Contact
  end

  def display_obj(obj)
    obj.display
  end
  
  def before_destroy
    if @obj.ref_id == current_user.primary_identity.id
      raise "Cannot delete own identity"
    end
  end
  
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

  def self.param_names
    [
      :contact_type,
      ref_attributes: [
        :id,
        :name,
        :birthday,
        :notes,
        {
          identity_phones_attributes: [:id, :number, :_destroy],
          identity_emails_attributes: [:id, :email, :_destroy],
          identity_locations_attributes: [
            :id,
            :_destroy,
            {
              location_attributes: LocationsController.param_names + [:id]
            }
          ],
          identity_drivers_licenses_attributes: [
            :id,
            :identifier,
            :expires,
            :region,
            :sub_region1,
            :_destroy,
            {
              identity_file_attributes: [
                :id,
                :file,
                :_destroy
              ]
            }
          ],
          identity_relationships_attributes: [
            :id,
            :relationship_type,
            :_destroy,
            {
              contact_attributes: [
                :id,
                :_destroy
              ]
            }
          ]
        }
      ]
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "ref_attributes"
        value.all?{|key2, value2| value2.blank?}
      else
        value.blank?
      end
    }
  end

  protected

    def sorts
      ["lower(identities.name) ASC"]
    end

    def obj_params
      params.require(:contact).permit(
        ContactsController.param_names,
        conversations_attributes: [:id, :conversation, :when, :_destroy]
      )
    end

    def all
      if @contact_type.blank?
        model.joins(:ref).where(
          identity_id: current_user.primary_identity.id
        )
      else
        model.joins(:ref).where(
          identity_id: current_user.primary_identity.id,
          contact_type: @contact_type
        )
      end
    end
    
    def before_all_actions
      # Create a Contact for the current user identity if it doesn't exist
      current_user.primary_identity.ensure_contact!
    end

    def update_presave
      check_nested_attributes(@obj, :conversations, :contact)
      check_nested_attributes(@obj.contact_identity, :identity_phones, :ref)
      check_nested_attributes(@obj.contact_identity, :identity_emails, :ref)
    end
end
