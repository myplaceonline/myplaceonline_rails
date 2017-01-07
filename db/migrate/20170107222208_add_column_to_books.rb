class AddColumnToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :book_category, :string
  end
end
