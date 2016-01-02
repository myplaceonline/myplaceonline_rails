# A negative amount means the contact is owed
class MoneyBalance < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :contact, presence: true
  
  def display
    if current_user_owns?
      contact.display
    else
      owner.display + "/" + contact.display
    end
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact

  has_many :money_balance_items, -> { order('item_time DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :money_balance_items, allow_destroy: true, reject_if: :all_blank
  
  def calculate_balance
    result = 0.0
    if money_balance_items.length > 0
      result = money_balance_items.map{|mbi| mbi.amount }.reduce(:+)
    end
    result
  end
end
