class CreditCard < ActiveRecord::Base
  include EncryptedConcern

  belongs_to :identity

  attr_accessor :encrypt
  
  validates :name, presence: true

  belongs_to :number_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :number

  validate do
    if number.blank? && number_encrypted.nil?
      errors.add(:number, t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :expires_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :expires

  validate do
    if expires.blank? && expires_encrypted.nil?
      errors.add(:expires, t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :security_code_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :security_code
  
  validate do
    if security_code.blank? && security_code_encrypted.nil?
      errors.add(:security_code, t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :pin_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :pin

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def password_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.password = Password.find(attributes['id'])
    end
    super
  end
  
  belongs_to :address, class_name: Location
  accepts_nested_attributes_for :address, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def address_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.address = Location.find(attributes['id'])
    end
    super
  end
end
