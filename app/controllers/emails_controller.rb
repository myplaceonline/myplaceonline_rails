class EmailsController < MyplaceonlineController
  
  def self.param_names
    [
      :id,
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
      ],
      email_personalizations_attributes: [
        :do_send,
        :target,
        :additional_text
      ]
    ]
  end

  def after_create
    AsyncEmailJob.perform_later(@obj)
    super
  end
  
  def redirect_to_obj
    redirect_to obj_path,
            :flash => { :notice =>
                        I18n.t("myplaceonline.emails.send_sucess_async")
                      }
  end

  protected
    def sorts
      ["emails.updated_at DESC"]
    end

    def obj_params
      params.require(:email).permit(EmailsController.param_names)
    end
end
