class CreateCrontabs < ActiveRecord::Migration[5.2]
  def change
    create_table :crontabs do |t|
      t.string :crontab_name
      t.integer :dblocker
      t.string :run_class
      t.string :run_method
      t.string :minutes
      t.datetime :last_success
      t.string :run_data
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
