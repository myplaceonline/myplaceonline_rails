class BankAccount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include EncryptedConcern
  include ModelHelpersConcern

  def display
    result = name
    if !archived.nil?
      result += " (" + I18n.t("myplaceonline.general.archived") + ")"
    end
    result
  end
  
  validates :name, presence: true

  belongs_to :account_number_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :account_number
  before_validation :account_number_finalize

  #validate do
  #  if account_number.blank? && account_number_encrypted.nil?
  #    errors.add(:account_number, I18n.t("myplaceonline.general.non_blank"))
  #  end
  #end

  belongs_to :routing_number_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :routing_number
  before_validation :routing_number_finalize

  #validate do
  #  if routing_number.blank? && routing_number_encrypted.nil?
  #    errors.add(:routing_number, I18n.t("myplaceonline.general.non_blank"))
  #  end
  #end

  belongs_to :pin_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :pin
  before_validation :pin_finalize

  child_property(name: :password)
  
  child_property(name: :home_address, model: Location)

  child_property(name: :company)

  def as_json(options={})
    if account_number_encrypted?
      options[:except] ||= %w(account_number routing_number pin)
    end
    super.as_json(options)
  end

  def self.skip_check_attributes
    ["encrypt"]
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
