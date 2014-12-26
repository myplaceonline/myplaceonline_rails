class Password < ExtendedRecord
  belongs_to :identity
  belongs_to :password_encrypted,
      class_name: EncryptedValue, dependent: :destroy, :autosave => true
  has_many :password_secrets, :dependent => :destroy
  accepts_nested_attributes_for :password_secrets, allow_destroy: true
  
  validates :name, presence: true
  
  def password
    if !password_encrypted?
      super
    else
      Myp.decrypt_from_session(
        ApplicationController.current_session,
        password_encrypted
      )
    end
  end
  
  def password_encrypted?
    !password_encrypted.nil?
  end
  
  def password_finalize(encrypt)
    if encrypt
      new_encrypted_value = Myp.encrypt_from_session(
        User.current_user,
        ApplicationController.current_session,
        self[:password]
      )
      self.password = nil
      if password_encrypted?
        Myp.copy_encrypted_value_attributes(
          new_encrypted_value,
          self.password_encrypted
        )
      else
        self.password_encrypted = new_encrypted_value
      end
    else
      if password_encrypted?
        self.password_encrypted.destroy!
        self.password_encrypted = nil
      end
    end
  end

  def get_url(prefertls = true)
    result = url
    if !result.to_s.empty?
      if prefertls && result.start_with?("http:")
        result = "https" + result[4..-1]
      end
      
      if (/^[^:]+:.*/ =~ result).nil?
        result = (prefertls ? "https://" : "http://") + result
      end
    end
    result
  end
  
  def display
    result = name
    if !user.to_s.empty?
      result += " (" + user + ")"
    end
    result
  end
  
  def as_json(options={})
    super.as_json(options).merge({
      :password_secrets => password_secrets.to_a.map{|x| x.as_json}
    })
  end
end
