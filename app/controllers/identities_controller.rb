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
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.identities.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(identities.name)"]
    end

    def obj_params
      params.require(:identity).permit(
        :name,
      )
    end

    def perform_all(initial_or:, additional:)
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

      @obj.identity = @obj
      
      MyplaceonlineExecutionContext.do_identity(@obj) do
        MyplaceonlineExecutionContext.do_permission_target(@obj) do
          @obj.after_create
        end
      end
      
      current_user.primary_identity = @obj
      current_user.save!
      
      nil
    end
end
