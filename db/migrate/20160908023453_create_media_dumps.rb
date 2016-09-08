class CreateMediaDumps < ActiveRecord::Migration
  def change
    create_table :media_dumps do |t|
      t.string :media_dump_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
