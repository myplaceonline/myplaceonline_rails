class CalculationsController < MyplaceonlineController
  def model
    Calculation
  end
  
  def after_create_or_update
    respond_to do |format|
      format.html {
        flash[:notice] = I18n.t("myplaceonline.calculations.result") + " = " + @obj.evaluate
        render :edit
      }
      format.js { super.after_create_or_update }
    end
  end

  protected
    def new_obj_initialize
      if !params[:form].nil?
        existing_form = User.current_user.primary_identity.calculation_forms_available.find(params[:form].to_i)
        if !existing_form.nil?
          @obj.original_calculation_form_id = existing_form.id
          create_presave
        end
      end
    end
    
    def sorts
      ["lower(calculations.name) ASC"]
    end

    def obj_params
      params.require(:calculation).permit(
        :name,
        :original_calculation_form_id,
        calculation_form_attributes: CalculationFormsController.param_names
      )
    end

    def create_presave
      if !@obj.original_calculation_form_id.nil? && @obj.calculation_form.nil?
        existing_form = User.current_user.primary_identity.calculation_forms_available.find(@obj.original_calculation_form_id)
        new_inputs = existing_form.calculation_inputs.map{|calculation_input| calculation_input.dup}
        @obj.calculation_form = existing_form.dup
        @obj.calculation_form.calculation_inputs = new_inputs
        @obj.calculation_form.is_duplicate = true
      end
    end
end
