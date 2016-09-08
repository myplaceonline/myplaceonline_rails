class WebsiteDomainRegistration < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_WEBSITE_DOMAIN_REGISTRATION_THRESHOLD_SECONDS = 2.weeks.seconds

  belongs_to :website_domain
  
  belongs_to :repeat
  accepts_nested_attributes_for :repeat, allow_destroy: true, reject_if: :all_blank
  validates_presence_of :repeat

  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: proc { |attributes| PeriodicPaymentsController.reject_if_blank(attributes) }
  allow_existing :periodic_payment

  def self.calendar_item_display(calendar_item)
    website_domain_registration = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.website_domains.registration_reminder",
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  def self.calendar_item_link(calendar_item)
    website_domain_registration = calendar_item.find_model_object
    "/website_domains/#{website_domain_registration.website_domain.id}"
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if MyplaceonlineExecutionContext.handle_updates?
      Repeat.create_calendar_reminders(
        self,
        "website_domain_registration_threshold_seconds",
        DEFAULT_WEBSITE_DOMAIN_REGISTRATION_THRESHOLD_SECONDS,
        Calendar::DEFAULT_REMINDER_TYPE
      )
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.primary_identity,
      self.class,
      model_id: id
    )
  end
end
