class InviteCodesController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.website_domain.nil? ? nil : obj.website_domain.display
  end
  
  def do_update_before_save
    pid = params.dig(:invite_code, :parent, :id)
    if !pid.blank?
      parent_invite_code = Myp.find_existing_object(InviteCode, pid.to_i)
      if !parent_invite_code.nil?
        @obj.parent_id = parent_invite_code.id
      end
    end
  end
  
  def precreate
    do_update_before_save
  end

  def footer_items_show
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result = [{
        title: I18n.t("myplaceonline.general.clone"),
        link: new_invite_code_path(clone: @obj.id),
        icon: "refresh"
      }] + result
    end
    
    result
  end

  protected
    def build_new_model
      if !params[:clone].blank?
        ic = InviteCode.where(id: params[:clone]).take!
        @obj.max_uses = ic.max_uses
        @obj.context_ids = ic.context_ids
        @obj.controversial = ic.controversial
        @obj.sexual = ic.sexual
        @obj.disable_signup_extras = ic.disable_signup_extras
        @obj.prefer_multi_profiles = ic.prefer_multi_profiles
        @obj.secondary_email = ic.secondary_email
        @obj.hidesuggestion = ic.hidesuggestion
        @obj.website_domain_id = ic.website_domain_id
      end
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.invite_codes.code"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(invite_codes.code)"]
    end

    def obj_params
      params.require(:invite_code).permit(
        :code,
        :current_uses,
        :max_uses,
        :public_name,
        :public_link,
        :public_description,
        :hidesuggestion,
        :context_ids,
        :sexual,
        :controversial,
        :disable_signup_extras,
        :prefer_multi_profiles,
        :secondary_email,
        website_domain_attributes: [:id],
        parent_attributes: [:id],
      )
    end

    def requires_admin
      true
    end

    def has_category
      false
    end
end
