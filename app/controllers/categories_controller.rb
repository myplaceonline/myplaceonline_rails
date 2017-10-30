class CategoriesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:show]

  def show_index_footer
    false
  end
  
  def allow_add
    false
  end

  def allow_edit
    false
  end

  def footer_items_show
    result = []
    result << {
      title: I18n.t("myplaceonline.general.back_to_list"),
      link: self.back_to_all_path,
      icon: "back"
    }
    result
  end

  protected
    def default_sort_columns
      ["categories.name"]
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.categories.name"), default_sort_columns[0]]
      ]
    end

    def all(strict: false)
      Category.all
    end
    
    def set_obj
      @obj = model.find_by(id: params[:id])
    end

    def additional_items?
      false
    end

    def has_category
      false
    end

end
