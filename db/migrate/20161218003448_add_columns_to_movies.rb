class AddColumnsToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :review, :text
    add_reference :movies, :lent_to, foreign_key: false
    add_foreign_key :movies, :contacts, column: :lent_to_id
    add_column :movies, :lent_date, :date
    add_reference :movies, :borrowed_from, foreign_key: false
    add_foreign_key :movies, :contacts, column: :borrowed_from_id
    add_column :movies, :borrowed_date, :date
  end
end
