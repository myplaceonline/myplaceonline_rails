class EmailsController < MyplaceonlineController
  
  def self.param_names
    [
      :id,
      :subject,
      :body,
      :copy_self,
      :email_category,
      :use_bcc,
      :draft,
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
    if !@obj.draft
      AsyncEmailJob.perform_later(@obj)
    end
    super
  end
  
  def redirect_to_obj
    if !@obj.draft
      redirect_to obj_path,
              :flash => { :notice =>
                          I18n.t("myplaceonline.emails.send_sucess_async")
                        }
    else
      super
    end
  end

  def index
    @draft = params[:draft]
    if !@draft.blank?
      @draft = @draft.to_bool
    end
    super
  end

  protected
    def sorts
      ["emails.updated_at DESC"]
    end

    def obj_params
      params.require(:email).permit(EmailsController.param_names)
    end

    def all_additional_sql(strict)
      if @draft && !strict
        "and draft = true"
      else
        nil
      end
    end
end
