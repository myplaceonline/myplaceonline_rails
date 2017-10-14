class RetirementPlansController < MyplaceonlineController
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.retirement_plans.add_retirement_plan_amount"),
        link: new_retirement_plan_retirement_plan_amount_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.retirement_plans.retirement_plan_amounts"),
        link: retirement_plan_retirement_plan_amounts_path(@obj),
        icon: "bars"
      },
    ]
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.retirement_plans.retirement_plan_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(retirement_plans.retirement_plan_name)"]
    end

    def obj_params
      params.require(:retirement_plan).permit(
        :retirement_plan_name,
        :started,
        :notes,
        :retirement_plan_type,
        company_attributes: Company.param_names,
        periodic_payment_attributes: PeriodicPaymentsController.param_names,
        password_attributes: PasswordsController.param_names
      )
    end
end
