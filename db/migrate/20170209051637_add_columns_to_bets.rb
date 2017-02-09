class AddColumnsToBets < ActiveRecord::Migration[5.0]
  def change
    add_column :bets, :bet_currency, :string
    add_column :bets, :bet_status, :integer
  end
end
