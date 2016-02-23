class CreatePermissionShareChildren < ActiveRecord::Migration
  def change
    create_table :permission_share_children do |t|
      t.string :subject_class
      t.integer :subject_id
      t.references :permission_share, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.references :share, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
