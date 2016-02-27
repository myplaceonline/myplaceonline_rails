class EmailsController < MyplaceonlineController
  
  def self.param_names
    [
      :subject,
      :body,
      :copy_self,
      :email_category,
      :use_bcc,
      email_contacts_attributes: [
        :id,
        :_destroy,
        contact_attributes: ContactsController.param_names
      ],
      email_groups_attributes: [
        :id,
        :_destroy,
        group_attributes: GroupsController.param_names
      ]
    ]
  end

  def after_create
    @obj.send_email
    super
  end
  
  protected
    def sorts
      ["emails.updated_at DESC"]
    end

    def obj_params
      params.require(:email).permit(EmailsController.param_names)
    end
end
