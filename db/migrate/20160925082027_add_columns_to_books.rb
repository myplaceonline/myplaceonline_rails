class AddColumnsToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :lent_to, index: true, foreign_key: false
    add_foreign_key :books, :contacts, column: :lent_to_id
    add_column :books, :lent_date, :date
    add_reference :books, :borrowed_from, index: true, foreign_key: false
    add_foreign_key :books, :contacts, column: :borrowed_from_id
    add_column :books, :borrowed_date, :date
  end
end
