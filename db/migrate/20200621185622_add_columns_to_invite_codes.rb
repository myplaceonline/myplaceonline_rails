class AddColumnsToInviteCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_codes, :public_name, :string
    add_column :invite_codes, :public_description, :text
    add_column :invite_codes, :public_link, :string
  end
end
