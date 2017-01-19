class Promotion < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  DEFAULT_PROMOTION_THRESHOLD_SECONDS = 15.days

  validates :promotion_name, presence: true
  
  def display
    result = promotion_name
    if !promotion_amount.nil?
      result += " (" + Myp.number_to_currency(promotion_amount) + ")"
    end
    if !expires.nil?
      result += " (" + I18n.t("myplaceonline.promotions.expires") + " " + Myp.display_date_short_year(expires, User.current_user) + ")"
    end
    result
  end

  def self.calendar_item_display(calendar_item)
    promotion = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.promotions.expires_soon",
      promotion_name: promotion.promotion_name,
      promotion_amount: Myp.number_to_currency(promotion.promotion_amount.nil? ? 0 : promotion.promotion_amount),
      expires_when: Myp.time_delta(promotion.expires)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      if !expires.nil?
        ApplicationRecord.transaction do
          CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
          User.current_user.primary_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.primary_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: expires,
              reminder_threshold_amount: (calendar.promotion_threshold_seconds || DEFAULT_PROMOTION_THRESHOLD_SECONDS),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: self.id)
  end
end
