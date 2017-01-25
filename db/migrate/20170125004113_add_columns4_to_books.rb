class AddColumns4ToBooks < ActiveRecord::Migration[5.0]
  def change
    add_reference :books, :gift_from, foreign_key: false
    add_foreign_key :books, :contacts, column: :gift_from_id
  end
end
