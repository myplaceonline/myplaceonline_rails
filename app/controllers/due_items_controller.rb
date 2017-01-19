class DueItemsController < MyplaceonlineController
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:complete, :snooze]

  def complete
    set_obj
    ApplicationRecord.transaction do
      ::CompleteDueItem.new(
        identity_id: @obj.identity_id,
        calendar: @obj.calendar,
        display: @obj.display,
        link: @obj.link,
        due_date: @obj.due_date,
        original_due_date: @obj.original_due_date,
        myp_model_name: @obj.myp_model_name,
        model_id: @obj.model_id
      ).save!
      
      ::SnoozedDueItem.where(identity: @obj.identity_id, myp_model_name: @obj.myp_model_name, model_id: @obj.model_id).each do |snoozed_item|
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
    duration = Myp.process_duration_timespan_short(params["duration"])
    if !duration.nil?
      new_due_date = Time.now + duration
      
      ApplicationRecord.transaction do
        ::SnoozedDueItem.new(
          identity_id: @obj.identity_id,
          calendar: @obj.calendar,
          display: @obj.display,
          link: @obj.link,
          due_date: new_due_date,
          original_due_date: @obj.original_due_date,
          myp_model_name: @obj.myp_model_name,
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
