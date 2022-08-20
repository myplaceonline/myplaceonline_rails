class CreateLifeChanges < ActiveRecord::Migration[6.1]
  def change
    create_table :life_changes do |t|
      t.string :life_change_title
      t.date :start_day
      t.date :end_day
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
