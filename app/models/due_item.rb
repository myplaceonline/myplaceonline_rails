class DueItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  
  belongs_to :calendar

  DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS = 3*60*60*24
  DEFAULT_PERIODIC_PAYMENT_AFTER_THRESHOLD_SECONDS = 3*60*60*24

  def self.periodic_payment_threshold_after(calendar)
    (calendar.periodic_payment_after_threshold_seconds || DEFAULT_PERIODIC_PAYMENT_AFTER_THRESHOLD_SECONDS).seconds
  end
  
  def self.periodic_payment_threshold_before(calendar)
    (calendar.periodic_payment_before_threshold_seconds || DEFAULT_PERIODIC_PAYMENT_BEFORE_THRESHOLD_SECONDS).seconds
  end
  
  def self.due_apartments(user, updated_record = nil, update_type = nil)
    destroy_due_items(user, Apartment)
    
    today = Date.today
    
    user.primary_identity.calendars.each do |calendar|
      Apartment.where("identity_id = ?", user.primary_identity).each do |apartment|
        apartment.apartment_trash_pickups.each do |trash_pickup|
          if trash_pickup.repeat
            next_pickup = trash_pickup.repeat.next_instance
            Rails.logger.debug{
              "Trash pickup: #{
                trash_pickup.inspect
              }, next: #{
                next_pickup
              }, threshold: #{
                trash_pickup_threshold(calendar)
              }, today: #{
                today
              }, diff: #{
                next_pickup - trash_pickup_threshold(calendar)
              }"
            }
            if next_pickup - trash_pickup_threshold(calendar) <= today
              create_due_item_check(
                display: I18n.t(
                  "myplaceonline.apartments.trash_pickup_reminder",
                  trash_type: Myp.get_select_name(trash_pickup.trash_type, ApartmentTrashPickup::TRASH_TYPES),
                  delta: Myp.time_difference_in_general_human(TimeDifference.between(Date.today, next_pickup).in_general)
                ),
                link: "/apartments/" + apartment.id.to_s,
                due_date: next_pickup,
                original_due_date: next_pickup,
                identity: user.primary_identity,
                calendar: calendar,
                myp_model_name: Apartment.name,
                model_id: apartment.id
              )
            end
          end
        end
      end
    end
  end
  
  def self.due_periodic_payments(user, updated_record = nil, update_type = nil)
    destroy_due_items(user, PeriodicPayment)
    
    today = Date.today
    
    user.primary_identity.calendars.each do |calendar|
      PeriodicPayment.where("identity_id = ? and date_period is not null and ended is null", user.primary_identity).each do |x|
        if !x.suppress_reminder
          result = x.next_payment
          if !result.nil?
            if result == today
              create_due_item_check(
                display: I18n.t(
                  "myplaceonline.periodic_payments.reminder_today",
                  name: x.display
                ),
                link: "/periodic_payments/" + x.id.to_s,
                due_date: result,
                original_due_date: result,
                identity: user.primary_identity,
                calendar: calendar,
                myp_model_name: PeriodicPayment.name,
                model_id: x.id
              )
            elsif result - self.periodic_payment_threshold_before(calendar) <= today
              create_due_item_check(
                display: I18n.t(
                  "myplaceonline.periodic_payments.reminder_before",
                  name: x.display,
                  delta: Myp.time_difference_in_general_human(TimeDifference.between(result, today).in_general)
                ),
                link: "/periodic_payments/" + x.id.to_s,
                due_date: result,
                original_due_date: result,
                identity: user.primary_identity,
                calendar: calendar,
                myp_model_name: PeriodicPayment.name,
                model_id: x.id
              )
            else
              if x.date_period == 0
                result = result.advance(months: -1)
              elsif x.date_period == 1
                result = result.advance(years: -1)
              elsif x.date_period == 2
                result = result.advance(months: -6)
              end
              if today - self.periodic_payment_threshold_after(calendar) <= result
                create_due_item_check(
                  display: I18n.t(
                    "myplaceonline.periodic_payments.reminder_after",
                    name: x.display,
                    delta: Myp.time_difference_in_general_human(TimeDifference.between(result, today).in_general)
                  ),
                  link: "/periodic_payments/" + x.id.to_s,
                  due_date: result,
                  original_due_date: result,
                  identity: user.primary_identity,
                  calendar: calendar,
                  myp_model_name: PeriodicPayment.name,
                  model_id: x.id
                )
              end
            end
          end
        end
      end
    end
  end
end
