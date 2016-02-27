class CreateGroupReferences < ActiveRecord::Migration
  def change
    create_table :group_references do |t|
      t.references :identity, index: true, foreign_key: true
      t.references :parent_group, index: true, foreign_key: false
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :group_references, :groups, column: :parent_group_id
  end
end
