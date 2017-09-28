class RemindersController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["reminders.start_time DESC"]
    end

    def obj_params
      params.require(:reminder).permit(
        :start_time,
        :reminder_name,
        :reminder_threshold_amount,
        :reminder_threshold_type,
        :expire_amount,
        :expire_type,
        :repeat_amount,
        :repeat_type,
        :max_pending,
        :notes,
      )
    end
end
