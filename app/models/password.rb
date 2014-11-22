class Password < ActiveRecord::Base  
  belongs_to :identity
  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy
  
  validates :name, presence: true
  
  validates_each :password do |record, attr, value|
    if (value.nil? || value.length == 0) && record.encrypted_password.nil?
      record.errors.add attr, I18n.t("errors.messages.blank")
    end
  end
  
  def getPassword(session)
    if !is_encrypted_password
      return password
    else
      return Myplaceonline.decryptFromSession(session, encrypted_password)
    end
  end
end
