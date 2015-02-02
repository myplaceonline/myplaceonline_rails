class BankAccount < ActiveRecord::Base
  include EncryptedConcern

  belongs_to :identity

  attr_accessor :encrypt
  
  validates :name, presence: true

  belongs_to :account_number_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :account_number

  validate do
    if account_number.blank? && account_number_encrypted.nil?
      errors.add(:account_number, t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :routing_number_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :routing_number

  validate do
    if routing_number.blank? && routing_number_encrypted.nil?
      errors.add(:routing_number, t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :pin_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :pin

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def password_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.password = Password.find(attributes['id'])
    end
    super
  end
  
  belongs_to :home_address, class_name: Location
  accepts_nested_attributes_for :home_address, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def home_address_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.home_address = Location.find(attributes['id'])
    end
    super
  end

  belongs_to :company, class_name: Company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def company_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.company = Company.find(attributes['id'])
    end
    super
  end

  def as_json(options={})
    if account_number_encrypted?
      options[:except] ||= %w(account_number routing_number pin)
    end
    super.as_json(options)
  end
end
