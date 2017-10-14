class DonationsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.donation_date, User.current_user)
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
        [I18n.t("myplaceonline.donations.donation_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["donations.donation_date", "lower(donations.donation_name) ASC"]
    end

    def obj_params
      params.require(:donation).permit(
        :donation_name,
        :donation_date,
        :amount,
        :notes,
        location_attributes: LocationsController.param_names,
        donation_files_attributes: FilesController.multi_param_names
      )
    end
end
