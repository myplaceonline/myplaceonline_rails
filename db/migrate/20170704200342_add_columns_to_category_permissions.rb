class AddColumnsToCategoryPermissions < ActiveRecord::Migration[5.1]
  def change
    add_reference :category_permissions, :target_identity, references: :identities, foreign_key: false
    add_foreign_key :category_permissions, :identities, column: :target_identity_id
  end
end
