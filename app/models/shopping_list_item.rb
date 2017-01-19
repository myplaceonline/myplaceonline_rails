class ShoppingListItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :shopping_list

  validates :shopping_list_item_name, presence: true
  
  def display
    shopping_list_item_name
  end
end
