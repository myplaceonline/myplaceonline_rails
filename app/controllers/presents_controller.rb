class PresentsController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.present_given, User.current_user)
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
        [I18n.t("myplaceonline.presents.present_given"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["presents.present_given"]
    end

    def obj_params
      params.require(:present).permit(
        :present_name,
        :notes,
        :present_given,
        :present_purchased,
        :present_amount,
        present_files_attributes: FilesController.multi_param_names,
        contact_attributes: ContactsController.param_names
      )
    end
end
