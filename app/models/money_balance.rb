# A negative amount means the contact is owed
class MoneyBalance < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :contact, presence: true
  
  def display
    if current_user_owns?
      contact.display
    else
      identity.display + "/" + contact.display
    end
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact

  has_many :money_balance_items, -> { order('item_time DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :money_balance_items, allow_destroy: true, reject_if: :all_blank
  
  has_many :money_balance_item_templates, :dependent => :destroy
  accepts_nested_attributes_for :money_balance_item_templates, allow_destroy: true, reject_if: :all_blank
  
  def calculate_balance
    result = 0.0
    if money_balance_items.length > 0
      result = money_balance_items.map{|mbi| mbi.amount }.reduce(:+)
    end
    result
  end
  
  def independent_description
    balance = calculate_balance
    if balance == 0
      Myp.number_to_currency(0)
    elsif balance < 0
      I18n.t("myplaceonline.money_balances.you_owe", source: identity.display, contact: contact.display, amount: Myp.number_to_currency(balance.abs))
    else
      I18n.t("myplaceonline.money_balances.contact_owes", source: identity.display, contact: contact.display, amount: Myp.number_to_currency(balance))
    end
  end
end
