class AddColumnMultiProfileToInviteCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :invite_codes, :prefer_multi_profiles, :boolean
  end
end
