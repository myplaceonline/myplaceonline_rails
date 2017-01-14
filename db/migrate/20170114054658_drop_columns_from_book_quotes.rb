class DropColumnsFromBookQuotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :book_quotes, :book_quote
  end
end
