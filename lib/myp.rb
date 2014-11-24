module Myp
  @categories = Hash.new
  @categories[:passwords] = Category.find_by(:name => :passwords)

  def self.categories
    return @categories
  end

  def self.rememberPassword(session, password)
    session[:password] = password
  end
  
  def self.encryptFromSession(user, session, message)
    if !session.has_key?(:password)
      raise Myp::DecryptionKeyUnavailableError
    end
    return self.encrypt(user, message, session[:password])
  end
  
  def self.encrypt(user, message, key)
    result = EncryptedValue.new
    result.encryption_type = 1
    result.user = user
    result.salt = SecureRandom.random_bytes(64)
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(result.salt)
    crypt = ActiveSupport::MessageEncryptor.new(generated_key)
    result.val = crypt.encrypt_and_sign(message)
    return result
  end
  
  def self.decryptFromSession(session, encrypted_value)
    if !session.has_key?(:password)
      raise Myp::DecryptionKeyUnavailableError
    end
    return self.decrypt(encrypted_value, session[:password])
  end
  
  def self.decrypt(encrypted_value, key)
    generated_key = ActiveSupport::KeyGenerator.new(key)
            .generate_key(encrypted_value.salt)
    crypt = ActiveSupport::MessageEncryptor.new(generated_key)
    return crypt.decrypt_and_verify(encrypted_value.val)
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
  
  class DecryptionKeyUnavailableError < StandardError; end
end
