class AddDefunctToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :defunct, :datetime
  end
end
