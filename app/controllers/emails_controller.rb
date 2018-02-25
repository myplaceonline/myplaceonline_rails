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
      :personalize,
      :suppress_signature,
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
      email_personalizations_attributes: EmailsController.email_personalizations_attributes 
    ]
  end
  
  def self.email_personalizations_attributes
    [
      :do_send,
      :target,
      :additional_text
    ]
  end
  
  def after_create
    if !@obj.draft
      if !@obj.personalize
        @obj.process
      end
    end
    super
  end
  
  def redirect_to_obj
    if !@obj.draft
      if !@obj.personalize
        final_redirect
      else
        Myp.clear_points_flash(session)
        redirect_to(email_personalize_path(@obj))
      end
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

  def personalize
    set_obj
    
    if !request.patch?
      @obj.all_targets.each do |email, contact|
        @obj.email_personalizations.build({target: email, do_send: true, contact: contact})
      end
    else
      @obj.update_attributes(params.require(:email).permit(
        email_personalizations_attributes: EmailsController.email_personalizations_attributes 
      ))
      if @obj.save
        @obj.process
        final_redirect
      end
    end
  end

  def new_save_text
    I18n.t("myplaceonline.emails.send") + " " + I18n.t("myplaceonline.category." + category_name).singularize + "(s)"
  end

  def footer_items_show
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.emails.duplicate"),
        link: new_email_path(duplicate: @obj.id),
        icon: "plus"
      }
    end
    
    result
  end
  
  def index_filters
    super + [
      {
        :name => :draft,
        :display => "myplaceonline.emails.draft"
      }
    ]
  end
  
  protected
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
        
    def final_redirect
      redirect_to obj_path,
            :flash => { :notice =>
                        I18n.t(@obj.send_immediately ? "myplaceonline.emails.send_sucess_sync" : "myplaceonline.emails.send_sucess_async")
                      }
    end

    def new_prerespond
      duplicate = params[:duplicate]
      if !duplicate.blank?
        duplicate_obj = Myp.find_existing_object(Email, duplicate)
        @obj.subject = duplicate_obj.subject
        @obj.email_category = duplicate_obj.email_category
        @obj.body = duplicate_obj.body
        duplicate_obj.email_contacts.each do |email_contact|
          @obj.email_contacts << EmailContact.new(contact: email_contact.contact)
        end
        duplicate_obj.email_groups.each do |email_group|
          @obj.email_groups << EmailGroup.new(group: email_group.group)
        end
      end
    end
end
