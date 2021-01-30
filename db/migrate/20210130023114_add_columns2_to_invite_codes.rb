class AddColumns2ToInviteCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_codes, :parent_id, :bigint
    add_foreign_key :invite_codes, :invite_codes, column: :parent_id
    add_index :invite_codes, :parent_id
    add_column :invite_codes, :hidesuggestion, :boolean
  end
end
