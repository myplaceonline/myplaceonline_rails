class CreateExports < ActiveRecord::Migration[5.1]
  def change
    create_table :exports do |t|
      t.string :export_name
      t.integer :export_type
      t.integer :export_status
      t.text :export_progress
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
