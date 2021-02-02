class AddColumns3ToInviteCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_codes, :context_ids, :string
  end
end
