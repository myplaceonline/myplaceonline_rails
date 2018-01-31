class CreditCard < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include EncryptedConcern
  include ModelHelpersConcern
  
  CARD_TYPES = [["myplaceonline.credit_cards.visa", 0], ["myplaceonline.credit_cards.mastercard", 1], ["myplaceonline.credit_cards.amex", 2]]

  before_validation :process_cc_name
  
  # We do this on save rather than in display because if we access self.name
  # in display and the credit card is encrypted, then we'll have to decrypt
  # just to show the name.
  # TODO instead save off the last four digits into the model
  def process_cc_name
    if !self.name.blank? && !self.number.blank? && self.number.length >= 4
      r = Regexp.new(' \([0-9]{4}\)')
      while !r.match(self.name).nil? do
        self.name = self.name.gsub(r, "")
      end
      self.name += " (" + self.number.last(4) + ")"
    end
  end

  def display(show_default_cashback = true)
    result = name
    if !card_type.nil?
      result += " (" + Myp.get_select_name(card_type, CreditCard::CARD_TYPES) + ")"
    end
    if !archived.nil?
      result += " (" + I18n.t("myplaceonline.general.archived") + ")"
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

  belongs_to :number_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :number
  before_validation :number_finalize

  validate do
    if number.blank? && number_encrypted.nil?
      errors.add(:number, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :expires_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :expires
  before_validation :expires_finalize

  validate do
    if expires.blank? && expires_encrypted.nil?
      errors.add(:expires, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :security_code_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :security_code
  before_validation :security_code_finalize
  
  validate do
    if security_code.blank? && security_code_encrypted.nil?
      errors.add(:security_code, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  belongs_to :pin_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :pin
  before_validation :pin_finalize

  child_property(name: :password)
  
  child_property(name: :address, model: Location)

  def as_json(options={})
    if number_encrypted?
      options[:except] ||= %w(number expires security_code pin)
    end
    super.as_json(options)
  end
  
  child_properties(name: :credit_card_cashbacks)

  child_files

  def self.skip_check_attributes
    ["encrypt", "email_reminders"]
  end

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("#{self.table_name}_most_visited_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.general.most_visited")
  end

  def self.category_split_button_icon
    "star"
  end
end
