class Password < ActiveRecord::Base  
  belongs_to :identity
  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy
  has_many :password_secrets, :dependent => :destroy
  accepts_nested_attributes_for :password_secrets
  
  validates :name, presence: true
  
  validates_each :password do |record, attr, value|
    if (value.nil?) && record.encrypted_password.nil?
      record.errors.add attr, I18n.t("errors.messages.blank")
    end
  end
  
  def getPassword(session)
    if !is_encrypted_password
      password
    else
      Myp.decrypt_from_session(session, encrypted_password)
    end
  end
  
  def getURL(prefertls = true)
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
