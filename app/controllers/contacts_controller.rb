class ContactsController < MyplaceonlineController
  protected
    def model
      Contact
    end

    def sorts
      ["contacts.created_at ASC"]
    end

    def display_obj(obj)
      obj.name
    end

    def obj_params
      params.require(:contact).permit(
        ref_attributes: [:id, :name]
      )
    end

    def new_build
      @obj.ref = Identity.new
    end
end
