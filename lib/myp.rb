class Myp
  def self.rememberPassword(session, password)
    session[:password] = password
  end
  
  def self.encrypt(session, message)
    salt = SecureRandom.random_bytes(64)
    key = ActiveSupport::KeyGenerator.new(session[:password]).generate_key(salt)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(message)
    EncryptionHolder.new(salt, encrypted_data)
  end
  
  def self.decrypt(session, encryption_holder)
    key = ActiveSupport::KeyGenerator.new(session[:password])
            .generate_key(encryption_holder.salt)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(encryption_holder.encrypted_data)
  end
  
  class EncryptionHolder
    def initialize(salt, encrypted_data)
      @salt = salt
      @encrypted_data = encrypted_data
    end
  end
end
