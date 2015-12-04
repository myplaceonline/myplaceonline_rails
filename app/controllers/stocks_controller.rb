class StocksController < MyplaceonlineController
  protected
    def sorts
      ["stocks.updated_at DESC"]
    end

    def obj_params
      params.require(:stock).permit(
        :num_shares,
        :vest_date,
        :notes,
        Myp.select_or_create_permit(params[:stock], :company_attributes, CompaniesController.param_names(params[:stock][:company_attributes])),
        Myp.select_or_create_permit(params[:stock], :password_attributes, PasswordsController.param_names)
      )
    end
end
