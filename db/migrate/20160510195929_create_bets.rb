class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.string :bet_name
      t.date :bet_start_date
      t.date :bet_end_date
      t.decimal :bet_amount, precision: 10, scale: 2
      t.decimal :odds_ratio, precision: 10, scale: 2
      t.boolean :odds_direction_owner
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
