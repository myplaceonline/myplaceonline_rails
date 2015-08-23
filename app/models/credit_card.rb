class CreditCard < MyplaceonlineIdentityRecord
  include AllowExistingConcern
  include EncryptedConcern
  
  CARD_TYPES = [["myplaceonline.credit_cards.visa", 0], ["myplaceonline.credit_cards.mastercard", 1], ["myplaceonline.credit_cards.amex", 2]]

  attr_accessor :is_defunct

  def display(show_default_cashback = true)
    result = name
    if !card_type.nil?
      result += " (" + Myp.get_select_name(card_type, CreditCard::CARD_TYPES) + ")"
    end
    if !defunct.nil?
      result += " (" + I18n.t("myplaceonline.general.defunct") + ")"
    end
    if show_default_cashback
      default_cashbacks = credit_card_cashbacks.to_a.keep_if{|wrapper| wrapper.cashback.default_cashback}
      if default_cashbacks.length > 0
        result += " (" + default_cashbacks[0].cashback.cashback_percentage.to_s + "%)"
      end
    end
    result
  end
  
  def is_expired
    if !expires.nil?
      if Date.today <= expires
        false
      else
        true
      end
    else
      true
    end
  end
  
  validates :name, presence: true

  belongs_to :number_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :number

  validate do
    if number.blank? && number_encrypted.nil?
      errors.add(:number, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :expires_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :expires

  validate do
    if expires.blank? && expires_encrypted.nil?
      errors.add(:expires, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :security_code_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :security_code
  
  validate do
    if security_code.blank? && security_code_encrypted.nil?
      errors.add(:security_code, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :pin_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :pin

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
  
  belongs_to :address, class_name: Location
  accepts_nested_attributes_for :address, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :address, Location

  def as_json(options={})
    if number_encrypted?
      options[:except] ||= %w(number expires security_code pin)
    end
    super.as_json(options)
  end
  
  has_many :credit_card_cashbacks, :dependent => :destroy
  accepts_nested_attributes_for :credit_card_cashbacks, allow_destroy: true, reject_if: :all_blank
end
