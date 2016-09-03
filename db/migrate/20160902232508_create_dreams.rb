class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.string :dream_name
      t.datetime :dream_time
      t.text :dream
      t.references :dream_encrypted, index: true, foreign_key: false
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_reference :dreams, :dream_encrypted_id, index: true, foreign_key: false
    add_foreign_key :dreams, :encrypted_values, column: :dream_encrypted_id
  end
end
