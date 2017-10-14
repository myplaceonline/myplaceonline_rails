class InsuranceCardsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.appendstr(
      Myp.display_date_month_year_simple(obj.insurance_card_start, User.current_user),
      Myp.display_date_month_year_simple(obj.insurance_card_end, User.current_user),
      " to "
    )
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
        [I18n.t("myplaceonline.insurance_cards.insurance_card_end"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["insurance_cards.insurance_card_end"]
    end

    def obj_params
      params.require(:insurance_card).permit(
        :insurance_card_name,
        :insurance_card_start,
        :insurance_card_end,
        :notes,
        insurance_card_files_attributes: FilesController.multi_param_names
      )
    end
end
