class DueItemsController < MyplaceonlineController
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:complete]

  def complete
    set_obj
    ActiveRecord::Base.transaction do
      ::CompleteDueItem.new(
        owner_id: User.current_user.id,
        display: @obj.display,
        link: @obj.link,
        due_date: @obj.due_date,
        model_name: @obj.model_name,
        model_id: @obj.model_id
      ).save!
      @obj.destroy!
    end
    render json: {
      result: true
    }
  end
  
  protected
    def sorts
      ["due_items.due_date"]
    end

    def obj_params
      params.require(:due_item).permit(
        :trash
      )
    end

    def has_category
      false
    end
end
