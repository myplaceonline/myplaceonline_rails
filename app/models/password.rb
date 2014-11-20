class Password < ActiveRecord::Base  
  validates :name, presence: true
  validates :password, presence: true
  
  belongs_to :identity
  belongs_to :encrypted_password, class_name: EncryptedValue
end
