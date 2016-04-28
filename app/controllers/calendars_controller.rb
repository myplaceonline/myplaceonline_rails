class CalendarsController < MyplaceonlineController
  def showmyplet
    @calendar_item_reminder_pendings = CalendarItemReminderPending.pending_items(current_user, @obj)
    if @calendar_item_reminder_pendings.length == 0
      @nocontent = true
    end
  end
  
  def self.permit_params()
    [
      :exercise_threshold,
      :contact_best_friend_threshold,
      :contact_good_friend_threshold,
      :contact_acquaintance_threshold,
      :contact_best_family_threshold,
      :contact_good_family_threshold,
      :dentist_visit_threshold,
      :doctor_visit_threshold,
      :status_threshold,
      :trash_pickup_threshold,
      :periodic_payment_before_threshold,
      :periodic_payment_after_threshold,
      :drivers_license_expiration_threshold,
      :birthday_threshold,
      :promotion_threshold,
      :gun_registration_expiration_threshold,
      :event_threshold,
      :stocks_vest_threshold,
      :todo_threshold,
      :website_domain_registration_threshold
    ]
  end
  
  protected
    def sorts
      ["calendars.updated_at DESC"]
    end

    def obj_params
      params.require(:calendar).permit(permit_params)
    end

    def has_category
      false
    end
end
