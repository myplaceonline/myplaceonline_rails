class Crontab < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :crontab_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :dblocker, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :run_class, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :run_method, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :minutes, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :last_success, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :run_data, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  validates :crontab_name, presence: true
  
  def display
    crontab_name
  end

  def self.run_crontabs(run_calendar_reminders: true)
    Rails.logger.info{"Crontab.run_crontabs started"}

    if run_calendar_reminders
      Rails.logger.info{"Crontab.run_crontabs CalendarItemReminder.ensure_pending_all_users started"}
      
      if Rails.env.production? || ENV["CRONTAB_CALENDARS"] == "true"
        CalendarItemReminder.ensure_pending_all_users
      end
      
      Rails.logger.info{"Crontab.run_crontabs CalendarItemReminder.ensure_pending_all_users finished"}
    end
    
    Crontab.all.each do |crontab|
      Rails.logger.info{"Crontab.run_crontabs checking crontab #{crontab.inspect}"}
      
      run = false
      
      if !crontab.last_success.nil?
        if !crontab.minutes.nil?
          if DateTime.now >= crontab.last_success + crontab.minutes.to_i.minutes
            run = true
          end
        end
      else
        # First run
        run = true
      end
      
      if run && !crontab.disabled?
        if crontab.identity.user.admin?
          Rails.logger.info{"Crontab.run_crontabs running #{crontab.inspect}"}
          
          c = Object.const_get(crontab.run_class)
          
          if !crontab.dblocker.nil?
            executed = Myp.try_with_database_advisory_lock(crontab.dblocker, 1) do
              c.send(crontab.run_method)
            end
            if !executed
              Rails.logger.info("Crontab.run_crontabs running could not lock (#{crontab.dblocker}, 1)")
            end
          else
            c.send(crontab.run_method)
          end
          
          MyplaceonlineExecutionContext.do_full_context(crontab.identity.user, crontab.identity) do
            crontab.last_success = DateTime.now
            crontab.save!
          end
        end
        
      end
      
      Rails.logger.info{"Crontab.run_crontabs finished crontab #{crontab.id}"}
    end

    Rails.logger.info{"Crontab.run_crontabs finished"}
  end
end
