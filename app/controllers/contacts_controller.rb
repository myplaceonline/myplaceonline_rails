class ContactsController < MyplaceonlineController
  protected
    def model
      Contact
    end

    def sorts
      ["lower(identities.name) ASC"]
    end

    def display_obj(obj)
      obj.name
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
end
