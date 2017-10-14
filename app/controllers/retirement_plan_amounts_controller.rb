class RetirementPlanAmountsController < MyplaceonlineController
  def path_name
    "retirement_plan_retirement_plan_amount"
  end

  def form_path
    "retirement_plan_amounts/form"
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.retirement_plan_amounts.retirement_plan"),
        link: retirement_plan_path(@parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.retirement_plan_amounts.retirement_plan"),
        link: retirement_plan_path(@obj.retirement_plan),
        icon: "back"
      }
    ] + super
  end

  def self.param_names
    [
      :input_date,
      :amount,
      :notes,
      retirement_plan_amount_files_attributes: FilesController.multi_param_names
    ]
  end

  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.retirement_plan_amounts.input_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["retirement_plan_amounts.input_date"]
    end

    def obj_params
      params.require(:retirement_plan_amount).permit(RetirementPlanAmountsController.param_names)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      RetirementPlan
    end
end
