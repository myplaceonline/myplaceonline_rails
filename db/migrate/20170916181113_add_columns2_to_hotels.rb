class AddColumns2ToHotels < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :checkin_date, :date
    add_column :hotels, :checkout_date, :date
    add_column :hotels, :confirmation_number, :string
  end
end
