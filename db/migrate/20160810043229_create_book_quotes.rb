class CreateBookQuotes < ActiveRecord::Migration
  def change
    create_table :book_quotes do |t|
      t.references :book, index: true, foreign_key: true
      t.text :book_quote
      t.string :pages
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
