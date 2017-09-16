class AddColumnsWebsiteToFlights < ActiveRecord::Migration[5.1]
  def change
    add_reference :flights, :website, foreign_key: true
    add_column :flights, :website_confirmation_number, :string
    add_column :flights, :total_cost, :decimal, precision: 10, scale: 2
  end
end
