module Myp
  def self.rememberPassword(session, password)
    session[:password] = password
  end
  
  def self.encryptFromSession(session, message)
    if !session.has_key?(:password)
      raise Myp::DecryptionKeyUnavailableError
    end
    return self.encrypt(message, session[:password])
  end
  
  def self.encrypt(message, key)
    result = EncryptedValue.new
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
  
  class DecryptionKeyUnavailableError < StandardError; end
end
