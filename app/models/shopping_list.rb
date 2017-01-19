class ShoppingList < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :shopping_list_name, presence: true
  
  def display
    shopping_list_name
  end

  child_properties(name: :shopping_list_items)

  def all_shopping_list_items
    ShoppingListItem.where(
      shopping_list_id: id
    ).order(["shopping_list_items.position ASC"])
  end
end
