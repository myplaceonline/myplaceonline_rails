class Calendar < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include TimespanConcern
  
  DEFAULT_REMINDER_TYPE = Myp::REPEAT_TYPE_SECONDS
  DEFAULT_REMINDER_AMOUNT = 2.days
  
  has_many :calendar_items, :dependent => :destroy
  
  def display
    I18n.t("myplaceonline.calendars.calendar")
  end

  timespan_field :general_threshold
  timespan_field :exercise_threshold
  timespan_field :contact_best_friend_threshold
  timespan_field :contact_good_friend_threshold
  timespan_field :contact_acquaintance_threshold
  timespan_field :contact_best_family_threshold
  timespan_field :contact_good_family_threshold
  timespan_field :dentist_visit_threshold
  timespan_field :doctor_visit_threshold
  timespan_field :status_threshold
  timespan_field :trash_pickup_threshold
  timespan_field :periodic_payment_before_threshold
  timespan_field :periodic_payment_after_threshold
  timespan_field :drivers_license_expiration_threshold
  timespan_field :birthday_threshold
  timespan_field :promotion_threshold
  timespan_field :gun_registration_expiration_threshold
  timespan_field :event_threshold
  timespan_field :stocks_vest_threshold
  timespan_field :todo_threshold
  timespan_field :vehicle_service_threshold
  timespan_field :happy_things_threshold
  
  def largest_threshold_seconds
    result = Calendar.max(
      Calendar::DEFAULT_REMINDER_AMOUNT,
      Exercise::DEFAULT_EXERCISE_THRESHOLD_SECONDS,
      Contact::DEFAULT_CONTACT_BEST_FRIEND_THRESHOLD_SECONDS,
      Contact::DEFAULT_CONTACT_GOOD_FRIEND_THRESHOLD_SECONDS,
      Contact::DEFAULT_CONTACT_ACQUAINTANCE_THRESHOLD_SECONDS,
      Contact::DEFAULT_CONTACT_BEST_FAMILY_THRESHOLD_SECONDS,
      Contact::DEFAULT_CONTACT_GOOD_FAMILY_THRESHOLD_SECONDS,
      DentistVisit::DEFAULT_DENTIST_VISIT_THRESHOLD_SECONDS,
      DoctorVisit::DEFAULT_DOCTOR_VISIT_THRESHOLD_SECONDS,
      Status::DEFAULT_STATUS_THRESHOLD_SECONDS,
      ApartmentTrashPickup::DEFAULT_TRASH_PICKUP_THRESHOLD_SECONDS,
      PeriodicPayment::DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS,
      PeriodicPayment::DEFAULT_PERIODIC_PAYMENT_AFTER_THRESHOLD_SECONDS,
      IdentityDriversLicense::DEFAULT_DRIVERS_LICENSE_EXPIRATION_THRESHOLD_SECONDS,
      Identity::DEFAULT_BIRTHDAY_THRESHOLD_SECONDS,
      Promotion::DEFAULT_PROMOTION_THRESHOLD_SECONDS,
      GunRegistration::DEFAULT_GUN_REGISTRATION_EXPIRATION_THRESHOLD_SECONDS,
      Event::DEFAULT_EVENT_THRESHOLD_SECONDS,
      Stock::DEFAULT_STOCKS_VEST_THRESHOLD_SECONDS,
      ToDo::DEFAULT_TODO_THRESHOLD_SECONDS,
      VehicleService::DEFAULT_VEHICLE_SERVICE_THRESHOLD_SECONDS,
      HappyThing::DEFAULT_HAPPY_THINGS_THRESHOLD
    ).seconds
    if !general_threshold_seconds.nil? && general_threshold_seconds > result
      result = general_threshold_seconds.seconds
    end
    if !exercise_threshold_seconds.nil? && exercise_threshold_seconds > result
      result = exercise_threshold_seconds.seconds
    end
    if !contact_best_friend_threshold_seconds.nil? && contact_best_friend_threshold_seconds > result
      result = contact_best_friend_threshold_seconds.seconds
    end
    if !contact_good_friend_threshold_seconds.nil? && contact_good_friend_threshold_seconds > result
      result = contact_good_friend_threshold_seconds.seconds
    end
    if !contact_acquaintance_threshold_seconds.nil? && contact_acquaintance_threshold_seconds > result
      result = contact_acquaintance_threshold_seconds.seconds
    end
    if !contact_best_family_threshold_seconds.nil? && contact_best_family_threshold_seconds > result
      result = contact_best_family_threshold_seconds.seconds
    end
    if !contact_good_family_threshold_seconds.nil? && contact_good_family_threshold_seconds > result
      result = contact_good_family_threshold_seconds.seconds
    end
    if !dentist_visit_threshold_seconds.nil? && dentist_visit_threshold_seconds > result
      result = dentist_visit_threshold_seconds.seconds
    end
    if !doctor_visit_threshold_seconds.nil? && doctor_visit_threshold_seconds > result
      result = doctor_visit_threshold_seconds.seconds
    end
    if !status_threshold_seconds.nil? && status_threshold_seconds > result
      result = status_threshold_seconds.seconds
    end
    if !trash_pickup_threshold_seconds.nil? && trash_pickup_threshold_seconds > result
      result = trash_pickup_threshold_seconds.seconds
    end
    if !periodic_payment_before_threshold_seconds.nil? && periodic_payment_before_threshold_seconds > result
      result = periodic_payment_before_threshold_seconds.seconds
    end
    if !periodic_payment_after_threshold_seconds.nil? && periodic_payment_after_threshold_seconds > result
      result = periodic_payment_after_threshold_seconds.seconds
    end
    if !drivers_license_expiration_threshold_seconds.nil? && drivers_license_expiration_threshold_seconds > result
      result = drivers_license_expiration_threshold_seconds.seconds
    end
    if !birthday_threshold_seconds.nil? && birthday_threshold_seconds > result
      result = birthday_threshold_seconds.seconds
    end
    if !promotion_threshold_seconds.nil? && promotion_threshold_seconds > result
      result = promotion_threshold_seconds.seconds
    end
    if !gun_registration_expiration_threshold_seconds.nil? && gun_registration_expiration_threshold_seconds > result
      result = gun_registration_expiration_threshold_seconds.seconds
    end
    if !event_threshold_seconds.nil? && event_threshold_seconds > result
      result = event_threshold_seconds.seconds
    end
    if !stocks_vest_threshold_seconds.nil? && stocks_vest_threshold_seconds > result
      result = stocks_vest_threshold_seconds.seconds
    end
    if !todo_threshold_seconds.nil? && todo_threshold_seconds > result
      result = todo_threshold_seconds.seconds
    end
    if !vehicle_service_threshold_seconds.nil? && vehicle_service_threshold_seconds > result
      result = vehicle_service_threshold_seconds.seconds
    end
    if !happy_things_threshold_seconds.nil? && happy_things_threshold_seconds > result
      result = happy_things_threshold_seconds.seconds
    end
    result
  end
  
  def self.amount_to_seconds(amount, amount_type)
    case amount_type
    when Myp::REPEAT_TYPE_SECONDS
      amount
    else
      raise "TODO"
    end
  end
  
  def self.max(*items)
    items.max
  end
end
