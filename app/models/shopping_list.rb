class ShoppingList < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :shopping_list_name, presence: true
  
  def display
    shopping_list_name
  end

  has_many :shopping_list_items, :dependent => :destroy
  accepts_nested_attributes_for :shopping_list_items, allow_destroy: true, reject_if: :all_blank

  def all_shopping_list_items
    ShoppingListItem.where(
      shopping_list_id: id
    ).order(["shopping_list_items.position ASC"])
  end
end
