class AddCategoryCreditCards < ActiveRecord::Migration
  def change
    Category.create(name: "credit_cards", link: "credit_cards", position: 0, parent: Category.find_by_name("order"))
  end
end
