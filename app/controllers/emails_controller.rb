class EmailsController < MyplaceonlineController
  protected
    def sorts
      ["emails.updated_at DESC"]
    end

    def obj_params
      params.require(:email).permit(
        :subject,
        :body,
        :copy_self,
        :email_category,
        email_contacts_attributes: [
          :id,
          :_destroy,
          contact_attributes: [
            :id
          ]
        ]
      )
    end
end
