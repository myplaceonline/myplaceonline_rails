class SnoozedDueItemsController < MyplaceonlineController
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.snoozed_due_items.due_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["snoozed_due_items.due_date"]
    end

    def obj_params
      params.require(:snoozed_due_item).permit(
        :display,
        :link,
        :due_date
      )
    end

    def has_category
      false
    end

    def additional_items?
      false
    end
end
