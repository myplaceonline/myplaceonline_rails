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
        :email_category
      )
    end
end
