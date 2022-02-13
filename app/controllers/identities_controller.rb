class IdentitiesController < MyplaceonlineController
  def do_check_double_post
    false
  end
  
  def make_public
    raise "Unauthorized"
  end
  
  def create_share_link
    raise "Unauthorized"
  end
  
  def after_create_redirect
    redirect_to "/"
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.website_domain.display
  end

  def data_split_icon
    Rails.env.development? ? "user" : ""
  end
  
  def split_link(obj)
    if Rails.env.development?
      ActionController::Base.helpers.link_to(
        I18n.t("myplaceonline.identities.emulate"),
        root_path + "?emulate_host=" + obj.website_domain.main_domain
      )
    else
      nil
    end
  end

  protected
    def sensitive
      true
    end
    
    def before_edit
      @obj.encrypt = @obj.ssn_encrypted?
    end
    
    def edit_prerespond
      @encrypt = current_user.encrypt_by_default
    end
    
    def build_new_model
      @encrypt = current_user.encrypt_by_default
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.identities.website_domain_id"), default_sort_columns[0]],
        [I18n.t("myplaceonline.identities.name"), "lower(identities.name)"]
      ]
    end

    def default_sort_columns
      ["identities.website_domain_id"]
    end

    def obj_params
      params.require(:identity).permit(
        :name,
        :last_name,
      )
    end

    def perform_all(initial_or:, additional:)
      Rails.logger.debug{"IdentitiesController.perform_all called with initial_or: #{initial_or}, additional: #{additional}"}
      model.includes(all_includes).joins(all_joins).where(
        "(#{model.table_name}.user_id = ? #{initial_or}) #{additional}",
        current_user.id
      )
    end

    def additional_items(strict: false)
      additional = all_additional_sql(strict)
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".user_id = ? and " + model.table_name + ".visit_count >= ? " + additional,
        current_user.id,
        additional_items_min_visit_count
      )
    end

    def favorite_items(strict: false)
      additional = all_additional_sql(strict)
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".user_id = ? and " + model.table_name + ".rating = ? " + additional,
        current_user.id,
        Myp::MAX_RATING
      )
    end

    def has_category
      false
    end

    def after_create
      
      @obj.user_id = current_user.id
      @obj.save!
      
      @obj.update_column(:website_domain_id, Myp.website_domain.id)
      @obj.reload
      
      @obj.identity = @obj
      
      MyplaceonlineExecutionContext.do_identity(@obj) do
        MyplaceonlineExecutionContext.do_permission_target(@obj) do
          @obj.after_create
        end
      end
      
      current_user.change_default_identity(@obj)
      
      nil
    end
end
