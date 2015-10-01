class DueItem < MyplaceonlineIdentityRecord
  def short_date
    if Date.today.year > due_date.year
      Myp.display_date_short_year(due_date, User.current_user)
    else
      Myp.display_date_short(due_date, User.current_user)
    end
  end
  
  def self.general_threshold
    60.days.from_now
  end
  
  def self.exercise_threshold
    7.days.ago
  end
  
  def self.timenow
    Time.now
  end
  
  def self.datenow
    Date.today
  end
  
  def self.contact_type_threshold
    result = Hash.new
    result[0] = 20.days.ago
    result[1] = 45.days.ago
    result[2] = 90.days.ago
    result[4] = 20.days.ago
    result[5] = 45.days.ago
    result
  end
  
  def self.dentist_visit_threshold
    5.months.ago
  end
  
  def self.doctor_visit_threshold
    11.months.ago
  end
  
  def self.status_threshold
    16.hours.ago
  end
  
  def self.all_due(user)
    DueItem.where(owner: user.primary_identity).order(:due_date)
  end
  
  def self.recalculate_due(user)
    ActiveRecord::Base.transaction do
      due_vehicles(user)
      due_contacts(user)
      due_exercises(user)
      due_promotions(user)
      due_gun_registrations(user)
      due_dental_cleanings(user)
      due_physicals(user)
      due_status(user)
    end
  end
  
  def self.recalculate_all_users_due()
    User.all.each do |user|
      begin
        User.current_user = user
        self.recalculate_due(user)
      ensure
        User.current_user = nil
      end
    end
  end
  
  def self.due_vehicles(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: Vehicle.name)
    
    Vehicle.where(owner: user.primary_identity).each do |vehicle|
      vehicle.vehicle_services.each do |service|
        if service.date_serviced.nil? && !service.date_due.nil?
          DueItem.new(
            display: service.short_description,
            link: "/vehicles/" + vehicle.id.to_s,
            due_date: service.date_due,
            owner: user.primary_identity,
            model_name: Vehicle.name,
            model_id: vehicle.id
          ).save!
        end
      end
    end
  end
  
  def self.due_contacts(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: Contact.name)
    
    IdentityDriversLicense.where("owner_id = ? and expires is not null and expires < ?", user.primary_identity, general_threshold).each do |drivers_license|
      contact = Contact.where(owner_id: user.primary_identity.id, identity_id: drivers_license.identity.id).first
      diff = TimeDifference.between(timenow, drivers_license.expires)
      if timenow >= drivers_license.expires
        # TODO expired
      end
      diff_in_general = diff.in_general
      DueItem.new(
        display: I18n.t(
          "myplaceonline.identities.license_expiring",
          license: drivers_license.display,
          time: Myp.time_difference_in_general_human(diff_in_general)
        ),
        link: "/contacts/" + contact.id.to_s,
        due_date: drivers_license.expires,
        owner: user.primary_identity,
        model_name: Contact.name,
        model_id: contact.id
      ).save!
    end

    Contact.where(owner: user.primary_identity).includes(:identity).to_a.each do |x|
      if !x.identity.nil? && !x.identity.birthday.nil?
        bday_this_year = Date.new(Date.today.year, x.identity.birthday.month, x.identity.birthday.day)
        if bday_this_year >= datenow && bday_this_year <= general_threshold
          diff = TimeDifference.between(datenow, bday_this_year)
          diff_in_general = diff.in_general
          DueItem.new(
            display: I18n.t(
              "myplaceonline.contacts.upcoming_birthday",
              name: x.display,
              delta: Myp.time_difference_in_general_human(diff_in_general)
            ),
            link: "/contacts/" + x.id.to_s,
            due_date: bday_this_year,
            owner: user.primary_identity,
            model_name: Contact.name,
            model_id: x.id
          ).save!
        end
      end
    end

    Contact.find_by_sql(%{
      SELECT contacts.*, max(conversations.conversation_date) as last_conversation_date
      FROM contacts
      LEFT OUTER JOIN conversations
        ON contacts.id = conversations.contact_id
      WHERE contacts.owner_id = #{user.primary_identity.id}
        AND contacts.contact_type IS NOT NULL
      GROUP BY contacts.id
      ORDER BY last_conversation_date ASC
    }).each do |contact|
      contact_threshold = contact_type_threshold[contact.contact_type]
      if !contact_threshold.nil?
        if contact.last_conversation_date.nil?
          # No conversations at all
          DueItem.new(
            display: I18n.t(
              "myplaceonline.contacts.no_conversations",
              name: contact.display,
              contact_type: Myp.get_select_name(contact.contact_type, Contact::CONTACT_TYPES)
            ),
            link: "/contacts/" + contact.id.to_s,
            due_date: datenow,
            owner: user.primary_identity,
            model_name: Contact.name,
            model_id: contact.id
          ).save!
        else
          if contact.last_conversation_date < contact_threshold
            DueItem.new(
              display: I18n.t(
                "myplaceonline.contacts.no_conversations_since",
                name: contact.display,
                contact_type: Myp.get_select_name(contact.contact_type, Contact::CONTACT_TYPES),
                delta: Myp.time_difference_in_general_human(TimeDifference.between(datenow, contact.last_conversation_date).in_general)
              ),
              link: "/contacts/" + contact.id.to_s,
              due_date: contact.last_conversation_date,
              owner: user.primary_identity,
              model_name: Contact.name,
              model_id: contact.id
            ).save!
          end
        end
      end
    end
  end
  
  def self.due_exercises(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: Exercise.name)
    
    last_exercise = Exercise.where("owner_id = ? and exercise_start is not null", user.primary_identity).order('exercise_start DESC').limit(1).first
    if !last_exercise.nil? and last_exercise.exercise_start < exercise_threshold
      DueItem.new(
        display: I18n.t(
          "myplaceonline.exercises.havent_exercised_for",
          delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_exercise.exercise_start).in_general)
        ),
        link: "/exercises/new",
        due_date: last_exercise.exercise_start,
        owner: user.primary_identity,
        model_name: Exercise.name
      ).save!
    end
  end
  
  def self.due_promotions(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: Promotion.name)
    
    Promotion.where("owner_id = ? and expires is not null and expires > ? and expires < ?", user.primary_identity, datenow, general_threshold).each do |promotion|
      DueItem.new(
        display: I18n.t(
          "myplaceonline.promotions.expires_soon",
          promotion_name: promotion.promotion_name,
          promotion_amount: Myp.number_to_currency(promotion.promotion_amount.nil? ? 0 : promotion.promotion_amount),
          expires_when: Myp.time_difference_in_general_human(TimeDifference.between(timenow, promotion.expires).in_general)
        ),
        link: "/promotions/" + promotion.id.to_s,
        due_date: promotion.expires,
        owner: user.primary_identity,
        model_name: Promotion.name,
        model_id: promotion.id
      ).save!
    end
  end
  
  def self.due_gun_registrations(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: GunRegistration.name)
    
    GunRegistration.where("owner_id = ? and expires is not null and expires > ? and expires < ?", user.primary_identity, datenow, general_threshold).each do |x|
      DueItem.new(
        display: I18n.t(
          "myplaceonline.gun_registrations.expires_soon",
          gun_name: x.gun.display,
          delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, x.expires).in_general)
        ),
        link: "/guns/" + x.gun.id.to_s,
        due_date: x.expires,
        owner: user.primary_identity,
        model_name: GunRegistration.name,
        model_id: x.gun.id
      ).save!
    end
  end
  
  def self.due_dental_cleanings(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: DentistVisit.name)
    
    last_dentist_visit = DentistVisit.where("owner_id = ? and cleaning = true", user.primary_identity).order('visit_date DESC').limit(1).first
    if !last_dentist_visit.nil? and last_dentist_visit.visit_date < dentist_visit_threshold
      DueItem.new(
        display: I18n.t(
          "myplaceonline.dentist_visits.no_cleaning_for",
          delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_dentist_visit.visit_date).in_general)
        ),
        link: "/dentist_visits/" + last_dentist_visit.id.to_s,
        due_date: last_dentist_visit.visit_date,
        owner: user.primary_identity,
        model_name: DentistVisit.name,
        model_id: last_dentist_visit.id
      ).save!
    elsif last_dentist_visit.nil?
      # If there are no dentist visits at all but there is a dental insurance company, then notify
      if DentalInsurance.where("owner_id = ? and (defunct is null)", user.primary_identity).count > 0
        DueItem.new(
          display: I18n.t(
            "myplaceonline.dentist_visits.no_cleanings"
          ),
          link: "/dentist_visits/new",
          due_date: timenow,
          owner: user.primary_identity,
          model_name: DentistVisit.name
        ).save!
      end
    end
  end
  
  def self.due_physicals(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: DoctorVisit.name)
    
    last_doctor_visit = DoctorVisit.where("owner_id = ? and physical = true", user.primary_identity).order('visit_date DESC').limit(1).first
    if !last_doctor_visit.nil? and last_doctor_visit.visit_date < doctor_visit_threshold
      DueItem.new(
        display: I18n.t(
          "myplaceonline.doctor_visits.no_physical_for",
          delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_doctor_visit.visit_date).in_general)
        ),
        link: "/doctor_visits/" + last_doctor_visit.id.to_s,
        due_date: last_doctor_visit.visit_date,
        owner: user.primary_identity,
        model_name: DoctorVisit.name,
        model_id: last_doctor_visit.id
      ).save!
    elsif last_doctor_visit.nil?
      # If there are no physicals at all but there is a health insurance company, then notify
      if HealthInsurance.where("owner_id = ? and (defunct is null)", user.primary_identity).count > 0
        DueItem.new(
          display: I18n.t(
            "myplaceonline.doctor_visits.no_physicals"
          ),
          link: "/doctor_visits/new",
          due_date: timenow,
          owner: user.primary_identity,
          model_name: DoctorVisit.name
        ).save!
      end
    end
  end
  
  def self.due_status(user)
    DueItem.destroy_all(owner: user.primary_identity, model_name: Status.name)
    
    last_status = Status.where("owner_id = ?", user.primary_identity).order('status_time DESC').limit(1).first
    if !last_status.nil? and last_status.status_time < status_threshold
      DueItem.new(
        display: I18n.t(
          "myplaceonline.statuses.no_recent_status",
          delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_status.status_time).in_general)
        ),
        link: "/statuses/new",
        due_date: last_status.status_time,
        owner: user.primary_identity,
        model_name: Status.name,
        model_id: last_status.id
      ).save!
    elsif last_status.nil?
      DueItem.new(
        display: I18n.t(
          "myplaceonline.statuses.no_statuses"
        ),
        link: "/statuses/new",
        due_date: timenow,
        owner: user.primary_identity,
        model_name: Status.name
      ).save!
    end
  end
end
