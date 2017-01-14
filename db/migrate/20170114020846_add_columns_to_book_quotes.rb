class AddColumnsToBookQuotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :book_quotes, :quote, foreign_key: true
  end
end
