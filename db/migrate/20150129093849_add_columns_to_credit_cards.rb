class AddColumnsToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :pin, :integer
    add_column :credit_cards, :notes, :text
  end
end
