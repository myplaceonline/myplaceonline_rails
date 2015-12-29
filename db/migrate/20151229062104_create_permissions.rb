class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :contact, index: true, foreign_key: true
      t.integer :action
      t.string :subject_class
      t.integer :subject_id
      t.integer :visit_count
      t.references :owner, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_foreign_key :permissions, :identities, column: :owner_id
  end
end
