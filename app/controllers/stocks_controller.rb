class StocksController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.vest_date, User.current_user)
  end

  def may_upload
    true
  end

  protected
    def obj_params
      params.require(:stock).permit(
        :num_shares,
        :vest_date,
        :notes,
        company_attributes: Company.param_names,
        password_attributes: PasswordsController.param_names,
        stock_files_attributes: FilesController.multi_param_names,
      )
    end
end
