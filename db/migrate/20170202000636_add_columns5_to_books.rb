class AddColumns5ToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :book_location, :string
  end
end
