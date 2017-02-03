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
        company_attributes: Company.param_names,
        password_attributes: PasswordsController.param_names
      )
    end
end
