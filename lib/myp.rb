require 'i18n'

module Myp
  # See https://github.com/digitalbazaar/forge/issues/207
  DEFAULT_AES_KEY_SIZE = 32
  @@all_categories = Hash.new.with_indifferent_access
  @@all_categories_without_explicit = Hash.new.with_indifferent_access

  # We want at least 128 bits of randomness, so
  # min(POSSIBILITIES_*.length)^DEFAULT_PASSWORD_LENGTH should be >= 2^128
  DEFAULT_PASSWORD_LENGTH = 22
  POSSIBILITIES_ALPHANUMERIC = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  POSSIBILITIES_ALPHANUMERIC_PLUS_SPECIAL = [('0'..'9'), ('a'..'z'), ('A'..'Z'), ['_', '-', '!']].map { |i| i.to_a }.flatten
  
  DEFAULT_DECIMAL_STEP = "0.01"
  
  WEIGHTS = [
    ["myplaceonline.general.pounds", 0]
  ]
  
  FOOD_WEIGHTS = [
    ["myplaceonline.general.pounds", 0],
    ["myplaceonline.general.cups", 1]
  ]
  
  DIMENSIONS = [["myplaceonline.general.inches", 0]]
  LIQUID_CAPACITY = [["myplaceonline.general.gallons", 0]]
  VOLUMES = [["myplaceonline.general.cubicft", 0]]
  
  # For things like vitamins
  MEASUREMENTS = [
    ["myplaceonline.measurements.micrograms", 0],
    ["myplaceonline.measurements.ius", 1],
    ["myplaceonline.measurements.milligrams", 2]
  ]
  
  # For things like medicines
  DOSAGES = [
    ["myplaceonline.measurements.micrograms", 0],
    ["myplaceonline.measurements.ius", 1],
    ["myplaceonline.measurements.milligrams", 2]
  ]
  
  INTENSITIES = [
    ["myplaceonline.intensities.one", 1],
    ["myplaceonline.intensities.two", 2],
    ["myplaceonline.intensities.three", 3],
    ["myplaceonline.intensities.four", 4],
    ["myplaceonline.intensities.five", 5]
  ]
  
  LIQUID_CONCENTRATIONS = [
    ["myplaceonline.liquid_concentrations.mgperdl", 1]
  ]
  
  TEMPERATURES = [
    ["myplaceonline.temperatures.fahrenheit", 0],
    ["myplaceonline.temperatures.celcius", 1]
  ]
  
  PERIODS = [
    ["myplaceonline.periods.monthly", 0],
    ["myplaceonline.periods.yearly", 1],
    ["myplaceonline.periods.six_months", 2]
  ]
  
  RATINGS = [
    ["myplaceonline.ratings.zero", 0],
    ["myplaceonline.ratings.one", 1],
    ["myplaceonline.ratings.two", 2],
    ["myplaceonline.ratings.three", 3],
    ["myplaceonline.ratings.four", 4],
    ["myplaceonline.ratings.five", 5]
  ]  
  
  NOISE_LEVELS = [
    ["myplaceonline.noise_levels.quiet", 0],
    ["myplaceonline.noise_levels.nature", 1],
    ["myplaceonline.noise_levels.mild", 2],
    ["myplaceonline.noise_levels.loud", 3],
    ["myplaceonline.noise_levels.very_loud", 4]
  ]

  puts "myplaceonline: Initializing categories"
  
  def self.database_exists?
    begin
      ActiveRecord::Base.connection.table_exists?(Category.table_name)
    rescue ActiveRecord::NoDatabaseError
      false
    end
  end

  if Myp.database_exists?
    Category.all.each do |existing_category|
      @@all_categories[existing_category.name.to_sym] = existing_category
      if existing_category.respond_to?("explicit?") && !existing_category.explicit?
        @@all_categories_without_explicit[existing_category.name.to_sym] = existing_category
      end
    end
    puts "myplaceonline: Categories: " + @@all_categories.map{|k, v| v.nil? ? "#{k} = nil" : "#{k} = #{v.id}/#{v.name.to_s}" }.inspect
  end
  
  def self.categories(user)
    if user.nil? || user.explicit_categories
      @@all_categories
    else
      @@all_categories_without_explicit
    end
  end

  # Return a list of CategoryForIdentity objects.
  # Assumes user is logged in.
  #
  # If parent is nil, search for all categories.
  # If parent is -1, search for all root categories.
  # Parent is is >= 0, search for all categories with a particular parent.
  def self.categories_for_current_user(user, parent = nil, orderByName = false)
    # We want a set of categories, left outer joined with points for each of
    # those for the current user, if available.
    #
    # Ideally we would use something like:
    #
    # Category.where(parent: nil).order(:position)
    #   .includes(:category_points_amounts)
    #   .where(category_points_amounts:
    #     {owner: user.primary_identity}
    #   )
    #
    # However, this places the where clause at the end instead of as an addition
    # to the LEFT OUTER JOIN clause, so we only get categories if the identity
    # has points for them.
    # 
    # Instead we could do a joins() call with an explicit LEFT OUTER JOIN and
    # the additional identity condition, but then we don't eager load the point
    # amounts, and if we go and get the point amounts, it won't go with the
    # identity condition.
    #
    # Therefore we have to fallback to direct SQL.

    # The first set of where clauses is to check that either the category has
    # no required user type mask, or if it has one, first whether the user has
    # a type mask (otherwise, there's no point in checking), and if so, if
    # the category mask is subsumed in the user mask
    where_clause = "WHERE (categories.user_type_mask IS NULL"
    if !user.user_type.nil?
      where_clause += " OR (" + user.user_type.to_s + " & categories.user_type_mask != 0)"
    end
    where_clause += ")"
    
    if !parent.nil?
      if parent == -1
        where_clause += " AND categories.parent_id IS NULL"
      else
        where_clause += " AND categories.parent_id = " + parent.id.to_s
      end
    end

    # By default, we don't show explicit categories
    explicit_check = Myp.get_categories_explicit_check_sql(user)
    if explicit_check.length > 0
      where_clause += " AND " + explicit_check
    end
    
    Category.find_by_sql(%{
      SELECT categories.*, category_points_amounts.count as points_amount
      FROM categories
      LEFT OUTER JOIN category_points_amounts
        ON category_points_amounts.category_id = categories.id
            AND category_points_amounts.owner_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
      #{ where_clause }
      ORDER BY #{
        orderByName ?
          "categories.name ASC" :
          "categories.position ASC, categories.name ASC"
      }
    }).map{ |category|
      CategoryForIdentity.new(
        category.human_title,
        "/" + category.link,
        category.points_amount.nil? ? 0 : category.points_amount,
        category.id,
        category.parent_id,
        category.filtertext,
        category.icon
      )
    }
  end
  
  def self.get_categories_explicit_check_sql(user)
    if user.nil? || !user.explicit_categories
      "(categories.explicit IS NULL OR categories.explicit = false)"
    else
      ""
    end
  end
  
  def self.useful_categories(user, recentlyVisited = 2, mostVisited = 3)
    # Prefer last visit over number of visits
    
    explicit_check = Myp.get_categories_explicit_check_sql(user)
    
    if explicit_check.length > 0
      explicit_check += " AND "
    end
    
    CategoryPointsAmount.find_by_sql(%{
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.icon as category_icon, categories.additional_filtertext as category_additional_filtertext, categories.link as category_link, categories.parent_id as category_parent_id, 0 as select_type
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE category_points_amounts.last_visit IS NOT NULL AND #{ explicit_check } categories.parent_id IS NOT NULL AND category_points_amounts.owner_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.last_visit DESC
        LIMIT #{ recentlyVisited }
      )
      UNION ALL
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.icon as category_icon, categories.additional_filtertext as category_additional_filtertext, categories.link as category_link, categories.parent_id as category_parent_id, 1 as select_type
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE category_points_amounts.visits IS NOT NULL AND #{ explicit_check } categories.parent_id IS NOT NULL AND category_points_amounts.owner_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.visits DESC
        LIMIT #{ mostVisited }
      )
    })
    .uniq{ |cpa| cpa.category_id }.map{ |cpa|
      CategoryForIdentity.new(
        Category.human_title(cpa.category_name),
        cpa.category_link,
        cpa.count.nil? ? 0 : cpa.count,
        cpa.category_id,
        cpa.category_parent_id,
        Category.filtertext(cpa.category_name, cpa.category_additional_filtertext),
        cpa.category_icon
      )
    }
  end

  class CategoryForIdentity
    def initialize(title, link, count, id, parent_id, filtertext, icon)
      @title = title
      @link = link
      @count = count
      @id = id
      @parent_id = parent_id
      @filtertext = filtertext
      @icon = ActionController::Base.helpers.asset_path(icon, type: :image)
    end
  end

  def self.markdown_to_html(markdown)
    if !markdown.nil?
      Kramdown::Document.new(markdown).to_html
    else
      nil
    end
  end
  
  def self.parse_yaml_to_html(id)
    str = I18n.t(id)
    xml = Nokogiri::XML("<xml>#{str}</xml>")
    cdata = xml.root.xpath("//xml").children.find{|e| e.cdata?}
    if !cdata.nil?
      markdown_to_html(cdata.text.strip)
    else
      raise "nil CDATA for #{xml}"
    end
  end
  
  WELCOME_FEATURES = self.parse_yaml_to_html("myplaceonline.welcome.features")
  CONTENT_FAQ = self.parse_yaml_to_html("myplaceonline.info.faq_content")
  CONTENT_TIPS = self.parse_yaml_to_html("myplaceonline.info.tips_content")
  
  def self.is_web_server?
    defined?(Rails::Server) || defined?(::PhusionPassenger)
  end
  
  def self.remember_password(session, password)
    session[:password] = password
  end
  
  def self.ensure_encryption_key(session)
    if session.nil?
      raise SessionUnavailableError
    end
    if !session.has_key?(:password)
      raise Myp::DecryptionKeyUnavailableError
    end
    session[:password]
  end
  
  def self.encrypt_from_session(user, session, message)
    self.ensure_encryption_key(session)
    self.encrypt(user, message, session[:password])
  end
  
  def self.encrypt(user, message, key)
    result = EncryptedValue.new
    self.encrypt_value(user, message, key, result)
  end
  
  def self.encrypt_value(user, message, key, value)
    if !message.nil? && !message.kind_of?(String)
      message = Myp.eye_catcher_marshalled + Marshal::dump(message)
    end
    # TODO OpenSSL::Cipher.update does not allow a nil or empty value
    if message.nil? || message == "" then
      message = " "
    end
    value.encryption_type = 1
    if user.nil?
      raise Myp::UserUnavailableError
    end
    value.user = user
    # OpenSSL only uses an 8 byte salt: https://www.openssl.org/docs/crypto/EVP_BytesToKey.html
    # "The standard recommends a salt length of at least [8 bytes]." (http://en.wikipedia.org/wiki/PBKDF2)
    value.salt = SecureRandom.random_bytes(8)
    # This uses PBKDF2+HMAC+SHA1 with an iteration count is 65536:
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/key_generator.rb
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(value.salt, Myp::DEFAULT_AES_KEY_SIZE)
    crypt = ActiveSupport::MessageEncryptor.new(generated_key, :serializer => SimpleSerializer.new)
    Rails.logger.debug("Performing encryption")
    value.val = crypt.encrypt_and_sign(message)
    value
  end
  
  def self.copy_encrypted_value_attributes(source, destination)
    destination.encryption_type = source.encryption_type
    destination.salt = source.salt
    destination.val = source.val
  end
  
  def self.decrypt_from_session(session, encrypted_value)
    if encrypted_value.nil?
      raise Myp::EncryptedValueUnavailableError
    end
    self.ensure_encryption_key(session)
    self.decrypt(encrypted_value, session[:password])
  end
  
  def self.decrypt(encrypted_value, key)
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(encrypted_value.salt, Myp::DEFAULT_AES_KEY_SIZE)
    crypt = ActiveSupport::MessageEncryptor.new(generated_key, :serializer => SimpleSerializer.new)
    Rails.logger.debug("Performing decryption")
    result = crypt.decrypt_and_verify(encrypted_value.val)
    if result.start_with?(Myp.eye_catcher_marshalled)
      #Rails.logger.debug{"un-marshalling: #{result}"}
      result = Marshal::load(result[Myp.eye_catcher_marshalled.length..-1])
    end
    result
  end
  
  def self.password_changed(user, old_password, new_password)
    if !old_password.eql?(new_password)
      ActiveRecord::Base.transaction do
        EncryptedValue.where(user: user).each do |encrypted_value|
          decrypted = self.decrypt(encrypted_value, old_password)
          self.encrypt_value(user, decrypted, new_password, encrypted_value)
          encrypted_value.save!
        end
      end
    end
  end
  
  def self.visit(user, categoryName)
    category = Myp.categories(user)[categoryName]
    if category.nil?
      raise "Could not find category " + categoryName + " (check Myp.website_init)"
    end
    cpa = CategoryPointsAmount.find_or_create_by(
      owner: user.primary_identity,
      category: category
    )
    if cpa.visits.nil?
      cpa.visits = 0
    end
    cpa.visits += 1
    cpa.last_visit = DateTime.now
    cpa.save
  end
  
  def self.add_point(user, categoryName)
    self.modify_points(user, categoryName, 1)
  end
  
  def self.subtract_point(user, categoryName)
    self.modify_points(user, categoryName, -1)
  end
  
  def self.modify_points(user, categoryName, amount)
    ActiveRecord::Base.transaction do
      if user.primary_identity.points.nil?
        user.primary_identity.points = 0
      end
      user.primary_identity.points += amount
      if user.primary_identity.points < 0
        user.primary_identity.points = 0
      end
      user.primary_identity.save
      
      category = Myp.categories(user)[categoryName]
      if category.nil?
        raise "Could not find category " + categoryName + " (check Myp.website_init)"
      end
      
      while !category.nil? do
        cpa = CategoryPointsAmount.find_or_create_by(
          owner: user.primary_identity,
          category: category
        )
        if cpa.count.nil?
          cpa.count = 0
        end
        cpa.count += amount
        if cpa.count < 0
          if !Rails.env.test?
            Myp.warn("Something went wrong, category count would go negative for #{category.inspect}")
          end
          break
        end
        cpa.save
        category = category.parent
      end
    end
  end
  
  def self.warn(message)
    # TODO send admin notification
  end
  
  def self.reset_points(user)
    ActiveRecord::Base.transaction do
      user.primary_identity.points = 0
      user.primary_identity.save
      
      CategoryPointsAmount.where(owner: user.primary_identity).update_all(count: 0)
    end
  end

  def self.reentry_url(request)
    "/users/reenter?redirect=" + URI.encode(request.path)
  end
  
  def self.error_details(error)
    error.inspect + "\n\t" + error.backtrace.join("\n\t")
  end
  
  def self.log_error(logger, error)
    logger.error(self.error_details(error))
  end
  
  class DecryptionKeyUnavailableError < StandardError; end
  class UserUnavailableError < StandardError; end
  class EncryptedValueUnavailableError < StandardError; end
  class SessionUnavailableError < StandardError; end
  class CannotFindNestedAttribute < StandardError; end

  class SimpleSerializer
    def dump(value)
      value
    end
    
    def load(value)
      value
    end
  end
  
  def self.select_listitem(selector)
    "$(this).addClass('ui-btn-active'); $('" + selector + "').val(object_extract_id(this)); return false;"
  end
  
  def self.display_date(time, current_user)
    self.display_time(time, current_user, :simple_date)
  end
  
  def self.display_datetime(time, current_user)
    self.display_time(time, current_user, :default)
  end
  
  def self.display_date_short(time, current_user)
    self.display_time(time, current_user, :short_date)
  end
  
  def self.display_date_short_year(time, current_user)
    self.display_time(time, current_user, :short_date_year)
  end
  
  def self.display_date_month_year(time, current_user)
    self.display_time(time, current_user, :month_year)
  end
  
  def self.display_datetime_short(time, current_user)
    self.display_time(time, current_user, :short_datetime)
  end
  
  def self.display_time(time, current_user, format = :default)
    if !time.nil?
      if !current_user.nil? && !current_user.timezone.blank?
        time = time.in_time_zone(current_user.timezone)
      else
        time = time.in_time_zone(Rails.application.config.time_zone)
      end
      if !time.nil?
        time.to_s(format)
      else
        nil
      end
    else
      nil
    end
  end
  
  def self.display_currency(obj, current_user)
    if !obj.blank?
      "$" + obj.to_s
    else
      nil
    end
  end

  def self.eye_catcher_marshalled
    "M4RSH4LLED_"
  end
  
  class DueItem
    def initialize(display, link, date)
      @display = display
      @link = link
      @date = date
    end
    
    def display
      @display
    end
    
    def link
      @link
    end
    
    def date
      @date
    end
    
    def short_date
      if Date.today.year > @date.year
        Myp.display_date_short_year(@date, User.current_user)
      else
        Myp.display_date_short(@date, User.current_user)
      end
    end
  end
  
  def self.due(user)
    result = Array.new

    general_threshold = 60.days.from_now
    exercise_threshold = 7.days.ago
    timenow = Time.now
    datenow = Date.today
    contact_type_threshold = Hash.new
    contact_type_threshold[0] = 20.days.ago
    contact_type_threshold[1] = 45.days.ago
    contact_type_threshold[2] = 90.days.ago
    contact_type_threshold[4] = 20.days.ago
    contact_type_threshold[5] = 45.days.ago
    dentist_visit_threshold = 5.months.ago
    doctor_visit_threshold = 11.months.ago
    status_threshold = 16.hours.ago
    
    Rails.logger.debug("Searching vehicles")

    Vehicle.where(owner: user.primary_identity).each do |vehicle|
      vehicle.vehicle_services.each do |service|
        if service.date_serviced.nil? && !service.date_due.nil?
          result.push(DueItem.new(service.short_description, "/vehicles/" + vehicle.id.to_s, service.date_due))
        end
      end
    end

    Rails.logger.debug("Searching driver's licenses")

    IdentityDriversLicense.where("owner_id = ? and expires is not null and expires < ?", user.primary_identity, general_threshold).each do |drivers_license|
      contact = Contact.where(owner_id: user.primary_identity.id, identity_id: drivers_license.identity.id).first
      diff = TimeDifference.between(timenow, drivers_license.expires)
      if timenow >= drivers_license.expires
	# TODO expired
      end
      diff_in_general = diff.in_general
      result.push(DueItem.new(I18n.t(
        "myplaceonline.identities.license_expiring",
        license: drivers_license.display,
        time: Myp.time_difference_in_general_human(diff_in_general)
      ), "/contacts/" + contact.id.to_s, drivers_license.expires))
    end
    
    Rails.logger.debug("Searching contacts")

    Contact.where(owner: user.primary_identity).includes(:identity).to_a.each do |x|
      if !x.identity.nil? && !x.identity.birthday.nil?
        bday_this_year = Date.new(Date.today.year, x.identity.birthday.month, x.identity.birthday.day)
        if bday_this_year >= datenow && bday_this_year <= general_threshold
          diff = TimeDifference.between(datenow, bday_this_year)
          diff_in_general = diff.in_general
          result.push(DueItem.new(I18n.t(
            "myplaceonline.contacts.upcoming_birthday",
            name: x.display,
            delta: Myp.time_difference_in_general_human(diff_in_general)
          ), "/contacts/" + x.id.to_s, bday_this_year))
        end
      end
    end
    
    Rails.logger.debug("Searching exercises")

    last_exercise = Exercise.where("owner_id = ? and exercise_start is not null", user.primary_identity).order('exercise_start DESC').limit(1).first
    if !last_exercise.nil? and last_exercise.exercise_start < exercise_threshold
      result.push(DueItem.new(I18n.t(
        "myplaceonline.exercises.havent_exercised_for",
        delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_exercise.exercise_start).in_general)
      ), "/exercises/" + last_exercise.id.to_s, last_exercise.exercise_start))
    end
    
    Rails.logger.debug("Searching promotions")

    Promotion.where("owner_id = ? and expires is not null and expires > ? and expires < ?", user.primary_identity, datenow, general_threshold).each do |promotion|
      result.push(DueItem.new(I18n.t(
        "myplaceonline.promotions.expires_soon",
        promotion_name: promotion.promotion_name,
        promotion_amount: Myp.number_to_currency(promotion.promotion_amount.nil? ? 0 : promotion.promotion_amount),
        expires_when: Myp.time_difference_in_general_human(TimeDifference.between(timenow, promotion.expires).in_general)
      ), "/promotions/" + promotion.id.to_s, promotion.expires))
    end
    
    Rails.logger.debug("Searching gun registrations")

    GunRegistration.where("owner_id = ? and expires is not null and expires > ? and expires < ?", user.primary_identity, datenow, general_threshold).each do |x|
      result.push(DueItem.new(I18n.t(
        "myplaceonline.gun_registrations.expires_soon",
        gun_name: x.gun.display,
        delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, x.expires).in_general)
      ), "/guns/" + x.gun.id.to_s, x.expires))
    end
    
    Rails.logger.debug("Searching conversations")

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
          result.push(DueItem.new(I18n.t(
            "myplaceonline.contacts.no_conversations",
            name: contact.display,
            contact_type: Myp.get_select_name(contact.contact_type, Contact::CONTACT_TYPES)
          ), "/contacts/" + contact.id.to_s, datenow))
        else
          if contact.last_conversation_date < contact_threshold
            result.push(DueItem.new(I18n.t(
              "myplaceonline.contacts.no_conversations_since",
              name: contact.display,
              contact_type: Myp.get_select_name(contact.contact_type, Contact::CONTACT_TYPES),
              delta: Myp.time_difference_in_general_human(TimeDifference.between(datenow, contact.last_conversation_date).in_general)
            ), "/contacts/" + contact.id.to_s, contact.last_conversation_date))
          end
        end
      end
    end
    
    Rails.logger.debug("Searching dental cleanings")

    last_dentist_visit = DentistVisit.where("owner_id = ? and cleaning = true", user.primary_identity).order('visit_date DESC').limit(1).first
    if !last_dentist_visit.nil? and last_dentist_visit.visit_date < dentist_visit_threshold
      result.push(DueItem.new(I18n.t(
        "myplaceonline.dentist_visits.no_cleaning_for",
        delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_dentist_visit.visit_date).in_general)
      ), "/dentist_visits/" + last_dentist_visit.id.to_s, last_dentist_visit.visit_date))
    elsif last_dentist_visit.nil?
      # If there are no dentist visits at all but there is a dental insurance company, then notify
      if DentalInsurance.where("owner_id = ? and (defunct is null)", user.primary_identity).count > 0
        result.push(DueItem.new(I18n.t(
          "myplaceonline.dentist_visits.no_cleanings"
        ), "/dentist_visits/new", timenow))
      end
    end
    
    Rails.logger.debug("Searching physicals")

    last_doctor_visit = DoctorVisit.where("owner_id = ? and physical = true", user.primary_identity).order('visit_date DESC').limit(1).first
    if !last_doctor_visit.nil? and last_doctor_visit.visit_date < doctor_visit_threshold
      result.push(DueItem.new(I18n.t(
        "myplaceonline.doctor_visits.no_physical_for",
        delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_doctor_visit.visit_date).in_general)
      ), "/doctor_visits/" + last_doctor_visit.id.to_s, last_doctor_visit.visit_date))
    elsif last_doctor_visit.nil?
      # If there are no physicals at all but there is a health insurance company, then notify
      if HealthInsurance.where("owner_id = ? and (defunct is null)", user.primary_identity).count > 0
        result.push(DueItem.new(I18n.t(
          "myplaceonline.doctor_visits.no_physicals"
        ), "/doctor_visits/new", timenow))
      end
    end
    
    Rails.logger.debug("Searching statuses")

    last_status = Status.where("owner_id = ?", user.primary_identity).order('status_time DESC').limit(1).first
    if !last_status.nil? and last_status.status_time < status_threshold
      result.push(DueItem.new(I18n.t(
        "myplaceonline.statuses.no_recent_status",
        delta: Myp.time_difference_in_general_human(TimeDifference.between(timenow, last_status.status_time).in_general)
      ), "/statuses/new", last_status.status_time))
    elsif last_status.nil?
      result.push(DueItem.new(I18n.t(
        "myplaceonline.statuses.no_statuses"
      ), "/statuses/new", timenow))
    end
    
    # sort due items
    result = result.sort{ |x,y| x.date <=> y.date }

    result
  end
  
  def self.time_difference_in_general_from_date(time, from)
    diff = TimeDifference.between(from, time)
    Myp.time_difference_in_general_human(diff.in_general)
  end
  
  def self.time_difference_in_general_from_now(time)
    diff = TimeDifference.between(Time.now, time)
    Myp.time_difference_in_general_human(diff.in_general)
  end
  
  def self.time_difference_in_general_human(diff)
    result = ""
    if diff[:years] > 0
      result += ActionController::Base.helpers.pluralize(diff[:years], "year")
    end
    if diff[:months] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:months], "month")
    end
    if diff[:weeks] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:weeks], "week")
    end
    if diff[:days] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:days], "day")
    end
    if result.length == 0
      if diff.values.reduce(:+) == 0
        result += I18n.t("myplaceonline.general.today")
      elsif diff[:hours] > 0
        result += ActionController::Base.helpers.pluralize(diff[:hours], "hour")
      end
    end
    result
  end
  
  def self.time_difference_in_general_human_detailed(diff)
    result = Myp.time_difference_in_general_human(diff)
    if diff[:hours] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:hours], "hour")
    end
    if diff[:minutes] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:minutes], "minute")
    end
    if diff[:seconds] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:seconds], "second")
    end
    result
  end
  
  def self.new_model(model, params = nil)
    if model.respond_to?("build")
      result = model.build(params)
    else
      result = model.new(params)
    end
    current_user = User.current_user
    if !current_user.nil? && result.respond_to?("owner_id=")
      result.owner_id = current_user.primary_identity.id
    end
    result
  end
  
  def self.get_select_name(val, select_values)
    if !val.nil?
      found = select_values.find{|x| x[1] == val}
      if !found.nil?
        I18n.t(found[0])
      else
        nil
      end
    else
      nil
    end
  end

  def self.translate_options(options)
    options.map{|o| [I18n.t(o[0]), o[1]]}
  end
  
  # When a form uses views/myplaceonline/_select_or_create.html.erb,
  # there's an accordian which either selects an existing item by ID,
  # or allows the creation of a new item. This function checks if the former
  # is submitted by checking if the id parameter (params[name][:id]) is
  # non-blank. If so, then only the "id" name is returned for permitted
  # parameters. If id is blank, we'll return the last parameter (all_array),
  # and also add on id just to avoid the unpermitted parameter warning (even
  # though we know it's blank and unused).
  def self.select_or_create_permit(params, name, all_array)
    if !params.nil? && !params[name].nil? && params[name][:id].blank?
      # Push :id on even though we know it's blank to avoid the unpermitted parameter warning
      { name => all_array.push(:id) }
    else
      { name => [:id] }
    end
  end
  
  def self.includes_today?(start_date, end_date)
    Myp.includes_date?(DateTime.now, start_date, end_date)
  end
  
  def self.includes_date?(the_date, start_date, end_date)
    if start_date.nil? && end_date.nil?
      true
    elsif start_date.nil?
      if the_date <= end_date
        true
      else
        false
      end
    elsif end_date.nil?
      if the_date >= start_date
        true
      else
        false
      end
    else
      if the_date >= start_date && the_date <= end_date
        true
      else
        false
      end
    end
  end

  def self.truncate_zeros(str)
    str.gsub("\.0", "")
  end
  
  def self.use_html5_inputs()
    result = true
    request = ApplicationController.current_request
    if !request.nil?
      if !request.user_agent.blank?
        if request.user_agent.include?("LG-D520")
          result = false
        end
      end
    end
    result
  end
  
  def self.number_to_currency(x)
    ActionController::Base.helpers.number_to_currency(x)
  end
  
  def self.number_with_delimiter(x)
    ActionController::Base.helpers.number_with_delimiter(x)
  end
  
  def self.migration_add_filtertext(category_name, filtertext)
    category = Category.where(name: category_name).first
    if category.nil?
      raise "Category not found"
    end
    if category.additional_filtertext.blank?
      category.additional_filtertext = filtertext
      puts "Set filtertext to #{filtertext}"
    else
      category.additional_filtertext += " " + filtertext
      puts "Updated filtertext to #{category.additional_filtertext}"
    end
    category.save!
  end
  
  def self.migration_set_icon(category_name, icon)
    category = Category.where(name: category_name).first
    if category.nil?
      raise "Category not found"
    end
    category.icon = icon
    puts "Set icon to #{icon}"
    category.save!
  end
  
  def self.appendstr(str, what, delimeter = " ", leftwrap = nil, rightwrap = nil)
    if !what.blank?
      if str.nil?
        str = ""
      else
        if !delimeter.nil?
          str += delimeter
        end
      end
      if !leftwrap.nil?
        str += leftwrap
      end
      str += what
      if !rightwrap.nil?
        str += rightwrap
      end
    end
    str
  end
  
  def self.appendstrwrap(str, what)
    Myp.appendstr(str, what, nil, " (", ")")
  end
  
  def self.query_parameters_uri_part(request)
    request.query_parameters().map{|k,v| URI.encode(k) + "=" + URI.encode(v)}.join("&")
  end

  PAGE_TRANSITIONS = [
    ["myplaceonline.page_transitions.none", 0],
    ["myplaceonline.page_transitions.fade", 1],
    ["myplaceonline.page_transitions.pop", 2],
    ["myplaceonline.page_transitions.flip", 3],
    ["myplaceonline.page_transitions.turn", 4],
    ["myplaceonline.page_transitions.flow", 5],
    ["myplaceonline.page_transitions.slidefade", 6],
    ["myplaceonline.page_transitions.slide", 7],
    ["myplaceonline.page_transitions.slideup", 8],
    ["myplaceonline.page_transitions.slidedown", 9]
  ]
  
  def self.page_transition_value_to_jqm(x)
    if x == 0
      "none"
    elsif x == 1
      "fade"
    elsif x == 2
      "pop"
    elsif x == 3
      "flip"
    elsif x == 4
      "turn"
    elsif x == 5
      "flow"
    elsif x == 6
      "slidefade"
    elsif x == 7
      "slide"
    elsif x == 8
      "slideup"
    elsif x == 9
      "slidedown"
    else
      nil
    end
  end
  
  CLIPBOARD_INTEGRATIONS = [
    ["myplaceonline.clipboard.none", 0],
    ["myplaceonline.clipboard.zeroclipboard", 1],
    ["myplaceonline.clipboard.ffclipboard", 2]
  ]
  
  def self.images_for_points(points)
    if !points.nil?
      if points == 42
        ActionController::Base.helpers.link_to "/badges/" + points.to_s do
          ActionController::Base.helpers.image_tag("FatCow_Icons16x16/hhg.png", height: "16", width: "16", alt: I18n.t("myplaceonline.points_image.n" + points.to_s), title: I18n.t("myplaceonline.points_image.n" + points.to_s))
        end
      else
        nil
      end
    else
      nil
    end
  end
  
  def self.set_existing_object(targetobj, targetname, model, id)
    if model.nil?
      model = Object.const_get(targetname.to_s.camelize)
    end
    obj = model.find_by(
      id: id,
      owner: User.current_user.primary_identity
    )
    if obj.nil?
      raise "Could not find " + model.to_s + " with ID " + id.to_s
    end
    targetobj.send(
      "#{targetname.to_s}=",
      obj
    )
  end
  
  def self.handle_exception(exception, email = nil, request = nil)
    stack = Myp.error_details(exception)
    body = ""
    if !email.nil?
      body += "User e-mail: " + email + "\n"
    end
    if !User.current_user.nil?
      body += User.current_user.inspect + "\n"
    end
    body += stack + "\n"
    if !request.nil?
      body += "Request: " + request.inspect + "\n"
    end
    puts "handle_exception: " + body
    Myp.send_support_email_safe("User Exception", body)
  end
  
  def self.send_support_email_safe(subject, body)
    begin
      from = I18n.t("myplaceonline.siteEmail")
      if !User.current_user.nil?
        from = User.current_user.email
      end
      UserMailer.send_support_email(from, subject, body).deliver
    rescue Exception => e
      puts "Could not send email. Subject: " + subject + ", Body: " + body + ", Email Problem: " + Myp.error_details(e)
    end
  end
  
  def self.instance_to_category(obj)
    search = obj.class.name.pluralize.underscore
    Category.all.each do |category|
      if category.name == search
        return category
      end
    end
    raise "Could not find category from " + search
  end
  
  def self.instance_to_category_human_readable(obj)
    Myp.instance_to_category(obj).human_title
  end
end
