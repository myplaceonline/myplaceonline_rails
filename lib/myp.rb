require 'i18n'

module Myp
  # See https://github.com/digitalbazaar/forge/issues/207
  @@DEFAULT_AES_KEY_SIZE = 32
  @@all_categories = Hash.new.with_indifferent_access

  # We want at least 128 bits of randomness, so
  # min(POSSIBILITIES_*.length)^DEFAULT_PASSWORD_LENGTH should be >= 2^128
  @@DEFAULT_PASSWORD_LENGTH = 22  
  @@POSSIBILITIES_ALPHANUMERIC = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  @@POSSIBILITIES_ALPHANUMERIC_PLUS_SPECIAL = [('0'..'9'), ('a'..'z'), ('A'..'Z'), ['_', '-', '!']].map { |i| i.to_a }.flatten

  puts "Myplaceonline: Initializing categories"
  if ActiveRecord::Base.connection.table_exists?(Category.table_name)
    @@all_categories[:order] = Category.find_by(:name => :order)
    @@all_categories[:joy] = Category.find_by(:name => :joy)
    @@all_categories[:meaning] = Category.find_by(:name => :meaning)
    @@all_categories[:passwords] = Category.find_by(:name => :passwords)
    @@all_categories[:movies] = Category.find_by(:name => :movies)
    @@all_categories[:wisdoms] = Category.find_by(:name => :wisdoms)
    @@all_categories[:to_dos] = Category.find_by(:name => :to_dos)
    @@all_categories[:contacts] = Category.find_by(:name => :contacts)
    @@all_categories[:files] = Category.find_by(:name => :files)
    @@all_categories[:accomplishments] = Category.find_by(:name => :accomplishments)
    @@all_categories[:feeds] = Category.find_by(:name => :feeds)
    @@all_categories[:locations] = Category.find_by(:name => :locations)
    @@all_categories[:activities] = Category.find_by(:name => :activities)
    @@all_categories[:apartments] = Category.find_by(:name => :apartments)
    @@all_categories[:jokes] = Category.find_by(:name => :jokes)
    @@all_categories[:companies] = Category.find_by(:name => :companies)
    @@all_categories[:promises] = Category.find_by(:name => :promises)
    @@all_categories[:subscriptions] = Category.find_by(:name => :subscriptions)
    @@all_categories[:credit_scores] = Category.find_by(:name => :credit_scores)
    @@all_categories[:websites] = Category.find_by(:name => :websites)
    @@all_categories[:credit_cards] = Category.find_by(:name => :credit_cards)
    @@all_categories[:bank_accounts] = Category.find_by(:name => :bank_accounts)
    puts "Myplaceonline: Categories: " + @@all_categories.map{|k, v| v.nil? ? "#{k} = nil" : "#{k} = #{v.id}/#{v.name.to_s}" }.inspect
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
  
  @@WELCOME_FEATURES = self.parse_yaml_to_html("myplaceonline.welcome.features")
  @@CONTENT_FAQ = self.parse_yaml_to_html("myplaceonline.info.faq_content")
  
  def self.is_web_server?
    defined?(Rails::Server) || defined?(::PhusionPassenger)
  end
  
  def self.default_password_length
    @@DEFAULT_PASSWORD_LENGTH
  end
  
  def self.password_possibilities_alphanumeric
    @@POSSIBILITIES_ALPHANUMERIC
  end
  
  def self.password_possibilities_alphanumeric_plus_special
    @@POSSIBILITIES_ALPHANUMERIC_PLUS_SPECIAL
  end
  
  def self.welcome_features
    @@WELCOME_FEATURES
  end
  
  def self.content_faq
    @@CONTENT_FAQ
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
    #     {identity: user.primary_identity}
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

    Category.find_by_sql(%{
      SELECT categories.*, category_points_amounts.count as points_amount
      FROM categories
      LEFT OUTER JOIN category_points_amounts
        ON category_points_amounts.category_id = categories.id
            AND category_points_amounts.identity_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
      #{ parent.nil? ?
           "" :
           %{
              WHERE categories.parent_id #{
                parent == -1 ?
                  "IS NULL" :
                  "= " + parent.id.to_s
              }
            }
       }
      ORDER BY #{
        orderByName ?
          "categories.name ASC" :
          "categories.position ASC, categories.name ASC"
      }
    }).map{ |category|
      CategoryForIdentity.new(
        I18n.t("myplaceonline.category." + category.name.downcase),
        category.link,
        category.points_amount.nil? ? 0 : category.points_amount,
        category.id,
        category.parent_id
      )
    }
  end
  
  def self.useful_categories(user)
    # Prefer last visit over number of visits
    CategoryPointsAmount.find_by_sql(%{
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.link as category_link, categories.parent_id as category_parent_id, 0 as select_type
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE categories.parent_id IS NOT NULL AND category_points_amounts.identity_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.last_visit DESC
        LIMIT 2
      )
      UNION ALL
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.link as category_link, categories.parent_id as category_parent_id, 1 as select_type
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE categories.parent_id IS NOT NULL AND category_points_amounts.identity_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.visits DESC
        LIMIT 2
      )
    })
    .uniq{ |cpa| cpa.category_id }.map{ |cpa|
      CategoryForIdentity.new(
        I18n.t("myplaceonline.category." + cpa.category_name.downcase),
        cpa.category_link,
        cpa.count.nil? ? 0 : cpa.count,
        cpa.category_id,
        cpa.category_parent_id
      )
    }
  end

  class CategoryForIdentity
    def initialize(title, link, count, id, parent_id)
      @title = title
      @link = link
      @count = count
      @id = id
      @parent_id = parent_id
    end
  end

  def self.categories
    @@all_categories
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
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(value.salt, @@DEFAULT_AES_KEY_SIZE)
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
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(encrypted_value.salt, @@DEFAULT_AES_KEY_SIZE)
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
    category = Myp.categories[categoryName]
    if category.nil?
      raise "Could not find category " + categoryName + " (check Myp.website_init)"
    end
    cpa = CategoryPointsAmount.find_or_create_by(
      identity: user.primary_identity,
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
      
      category = Myp.categories[categoryName]
      if category.nil?
        raise "Could not find category " + categoryName + " (check Myp.website_init)"
      end
      
      while !category.nil? do
        cpa = CategoryPointsAmount.find_or_create_by(
          identity: user.primary_identity,
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
      
      CategoryPointsAmount.where(identity: user.primary_identity).update_all(count: 0)
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
  
  def self.display_date_short(time, current_user)
    self.display_time(time, current_user, :short_date)
  end
  
  def self.display_date_month_year(time, current_user)
    self.display_time(time, current_user, :month_year)
  end
  
  def self.display_time(time, current_user, format = :rfc822)
    if !time.nil?
      if !current_user.nil? && !current_user.timezone.blank?
        time = time.in_time_zone(current_user.timezone)
      else
        time = time.in_time_zone(Rails.application.config.time_zone)
      end
      time.to_s(format)
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
  
  def self.authorize_value(record, attr, value)
    if !value.nil?
      Ability.new(User.current_user).authorize!(:manage, value)
    end
  end

  def self.eye_catcher_marshalled
    "M4RSH4LLED_"
  end
end
