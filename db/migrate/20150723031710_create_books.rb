class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :book_name
      t.string :isbn
      t.string :author
      t.datetime :when_read
      t.references :owner, index: true
      t.text :notes

      t.timestamps null: true
    end
  end
end
