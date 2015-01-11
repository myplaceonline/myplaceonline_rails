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

  def self.param_names
    [
      ref_attributes: [
        :id,
        :name,
        :birthday,
        :notes,
        {
          identity_phones_attributes: [:id, :number, :_destroy],
          identity_emails_attributes: [:id, :email, :_destroy],
        }
      ]
    ]
  end

  protected

    def sorts
      ["lower(identities.name) ASC"]
    end

    def obj_params
      params.require(:contact).permit(
        ContactsController.param_names,
        conversations_attributes: [:id, :conversation, :_destroy]
      )
    end

    def new_build
      @obj.ref = Identity.new
    end

    def all
      model.joins(:ref).where(
        identity_id: current_user.primary_identity.id
      )
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
