class MyplaceonlineDueDisplaysController < MyplaceonlineController
  def showmyplet
    @due = DueItem.all_due(current_user)
    if @due.length == 0
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
      :gun_registration_expiration_threshold
    ]
  end
  
  protected
    def sorts
      ["myplaceonline_due_displays.updated_at DESC"]
    end

    def obj_params
      params.require(:myplaceonline_due_display).permit(permit_params)
    end

    def has_category
      false
    end
end
