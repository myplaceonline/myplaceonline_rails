class ContactsController < MyplaceonlineController
  def model
    Contact
  end

  def display_obj(obj)
    obj.name
  end
  
  def before_destroy
    if @obj.ref_id == current_user.primary_identity.id
      raise "Cannot delete own identity"
    end
  end

  protected

    def sorts
      ["lower(identities.name) ASC"]
    end

    def obj_params
      params.require(:contact).permit(
        ref_attributes: [:id, :name, :birthday, :notes]
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
      if Contact.find_by(
        identity_id: current_user.primary_identity.id,
        ref_id: current_user.primary_identity.id
      ).nil?
        ActiveRecord::Base.transaction do
          me = Contact.new
          me.identity = current_user.primary_identity
          me.ref = current_user.primary_identity
          if current_user.primary_identity.name.blank?
            current_user.primary_identity.name = I18n.t("myplaceonline.contacts.me")
            current_user.primary_identity.save!
          end
          me.save!
        end
      end
    end
end
