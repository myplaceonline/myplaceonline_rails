class BankAccount < MyplaceonlineIdentityRecord
  include AllowExistingConcern
  include EncryptedConcern

  def display
    name
  end
  
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
  allow_existing :password
  
  belongs_to :home_address, class_name: Location
  accepts_nested_attributes_for :home_address, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :home_address, Location

  belongs_to :company, class_name: Company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :company

  def as_json(options={})
    if account_number_encrypted?
      options[:except] ||= %w(account_number routing_number pin)
    end
    super.as_json(options)
  end
end
