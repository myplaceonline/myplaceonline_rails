class AddColumnExtraFlagsToInviteCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_codes, :controversial, :boolean
    add_column :invite_codes, :sexual, :boolean
  end
end
