class DueItemsController < MyplaceonlineController
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:complete, :snooze]

  def complete
    set_obj
    ActiveRecord::Base.transaction do
      ::CompleteDueItem.new(
        owner_id: @obj.owner_id,
        display: @obj.display,
        link: @obj.link,
        due_date: @obj.due_date,
        original_due_date: @obj.original_due_date,
        model_name: @obj.model_name,
        model_id: @obj.model_id
      ).save!
      
      ::SnoozedDueItem.where(owner: @obj.owner_id, model_name: @obj.model_name, model_id: @obj.model_id).each do |snoozed_item|
        snoozed_item.destroy!
      end
      
      @obj.destroy!
    end
    render json: {
      result: true
    }
  end
  
  # When you snooze something, effectively it will never go away until
  # you complete it (with just a hias until it shows up during the snooze
  # period). So we simply delete the current due item, create a snoozed
  # due item and let it pick up after snooze on the next due item recalculation
  def snooze
    set_obj
    duration = process_duration(params["duration"])
    if !duration.nil?
      new_due_date = Time.now + duration
      
      ActiveRecord::Base.transaction do
        ::SnoozedDueItem.new(
          owner_id: @obj.owner_id,
          display: @obj.display,
          link: @obj.link,
          due_date: new_due_date,
          original_due_date: @obj.original_due_date,
          model_name: @obj.model_name,
          model_id: @obj.model_id
        ).save!
        @obj.destroy!
      end
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
