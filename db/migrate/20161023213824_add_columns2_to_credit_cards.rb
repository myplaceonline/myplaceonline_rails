class AddColumns2ToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :start_date, :date
  end
end
