class CreateHealthChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :health_changes do |t|
      t.string :change_name
      t.date :change_date
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
