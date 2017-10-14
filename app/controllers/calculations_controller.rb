class CalculationsController < MyplaceonlineController
  def after_update_redirect
    respond_to do |format|
      format.html {
        flash[:notice] = I18n.t("myplaceonline.calculations.result") + " = " + @obj.evaluate
        render :edit
      }
      format.js { super }
    end
  end
  
  def after_create_redirect
    respond_to do |format|
      format.html {
        flash[:notice] = I18n.t("myplaceonline.calculations.result") + " = " + @obj.evaluate
        render :edit
      }
      format.js { super }
    end
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.calculations.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(calculations.name)"]
    end

    def obj_params
      params.require(:calculation).permit(
        :name,
        :original_calculation_form_id,
        calculation_form_attributes: CalculationFormsController.param_names
      )
    end
end
