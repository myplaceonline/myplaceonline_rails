module Myp
  @categories = Hash.new
  @categories[:order] = Category.find_by(:name => :order)
  @categories[:joy] = Category.find_by(:name => :joy)
  @categories[:meaning] = Category.find_by(:name => :meaning)
  @categories[:passwords] = Category.find_by(:name => :passwords)
  
  # Return a list of CategoryForIdentity objects.
  # Assumes user is logged in.
  #
  # If parent is nil, search for all categories.
  # If parent is -1, search for all root categories.
  # Parent is is >= 0, search for all categories with a particular parent.
  def self.categoriesForCurrentUser(user, parent = nil, orderByName = false)
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
          "categories.position ASC"
      }
    }).map{ |category|
      CategoryForIdentity.new(
        I18n.t("myplaceonline.category." + category.name.downcase),
        category.link,
        category.points_amount.nil? ? 0 : category.points_amount
      )
    }
  end
  
  def self.usefulCategories(user)
    CategoryPointsAmount.find_by_sql(%{
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.link as category_link
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE categories.parent_id IS NOT NULL AND category_points_amounts.identity_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.last_visit DESC
        LIMIT 2
      )
      UNION
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.link as category_link
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE categories.parent_id IS NOT NULL AND category_points_amounts.identity_id = #{
                CategoryPointsAmount.sanitize(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.visits DESC
        LIMIT 2
      )
    })
    .map{ |cpa|
      CategoryForIdentity.new(
        I18n.t("myplaceonline.category." + cpa.category_name.downcase),
        cpa.category_link,
        cpa.count
      )
    }
  end

  class CategoryForIdentity
    def initialize(title, link, count)
      @title = title
      @link = link
      @count = count
    end
  end

  def self.categories
    return @categories
  end

  def self.rememberPassword(session, password)
    session[:password] = password
  end
  
  def self.ensureEncryptionKey(session)
    if !session.has_key?(:password)
      raise Myp::DecryptionKeyUnavailableError
    end
  end
  
  def self.encryptFromSession(user, session, message)
    self.ensureEncryptionKey(session)
    return self.encrypt(user, message, session[:password])
  end
  
  def self.encrypt(user, message, key)
    result = EncryptedValue.new
    return self.encryptValue(user, message, key, result)
  end
  
  def self.encryptValue(user, message, key, value)
    value.encryption_type = 1
    value.user = user
    value.salt = SecureRandom.random_bytes(64)
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(value.salt)
    crypt = ActiveSupport::MessageEncryptor.new(generated_key)
    value.val = crypt.encrypt_and_sign(message)
    return value
  end
  
  def self.decryptFromSession(session, encrypted_value)
    self.ensureEncryptionKey(session)
    return self.decrypt(encrypted_value, session[:password])
  end
  
  def self.decrypt(encrypted_value, key)
    generated_key = ActiveSupport::KeyGenerator.new(key)
            .generate_key(encrypted_value.salt)
    crypt = ActiveSupport::MessageEncryptor.new(generated_key)
    return crypt.decrypt_and_verify(encrypted_value.val)
  end
  
  def self.passwordChanged(user, old_password, new_password)
    if !old_password.eql?(new_password)
      ActiveRecord::Base.transaction do
        EncryptedValue.where(user: user).each do |encrypted_value|
          decrypted = self.decrypt(encrypted_value, old_password)
          self.encryptValue(user, decrypted, new_password, encrypted_value)
          encrypted_value.save!
        end
      end
    end
  end
  
  def self.visit(user, categoryName)
    cpa = CategoryPointsAmount.find_or_create_by(
      identity: user.primary_identity,
      category: @categories[categoryName]
    )
    if cpa.visits.nil?
      cpa.visits = 0
    end
    cpa.visits += 1
    cpa.last_visit = DateTime.now
    cpa.save
  end
  
  def self.addPoint(user, categoryName)
    self.modifyPoints(user, categoryName, 1)
  end
  
  def self.subtractPoint(user, categoryName)
    self.modifyPoints(user, categoryName, -1)
  end
  
  def self.modifyPoints(user, categoryName, amount)
    ActiveRecord::Base.transaction do
      if user.primary_identity.points.nil?
        user.primary_identity.points = 0
      end
      user.primary_identity.points += amount
      if user.primary_identity.points < 0
        user.primary_identity.points = 0
      end
      user.primary_identity.save
      
      category = @categories[categoryName]
      
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
          cpa.count = 0
        end
        cpa.save
        category = category.parent
      end
    end
  end
  
  def self.resetPoints(user)
    ActiveRecord::Base.transaction do
      user.primary_identity.points = 0
      user.primary_identity.save
      
      CategoryPointsAmount.where(identity: user.primary_identity).update_all(count: 0)
    end
  end
  
  def self.getReentryURL(request)
    "/users/reenter?redirect=" + URI.encode(request.path)
  end
  
  def self.getErrorDetails(error)
    return error.inspect + "\n\t" + error.backtrace.join("\n\t")
  end
  
  def self.logError(logger, error)
    logger.error(self.getErrorDetails(error))
  end
  
  class DecryptionKeyUnavailableError < StandardError; end
end
