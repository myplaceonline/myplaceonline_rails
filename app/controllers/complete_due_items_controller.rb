class CompleteDueItemsController < MyplaceonlineController
  
  protected
    def sorts
      ["complete_due_items.due_date"]
    end

    def obj_params
      params.require(:complete_due_item).permit(
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
