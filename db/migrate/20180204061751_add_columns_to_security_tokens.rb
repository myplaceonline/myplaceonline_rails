class AddColumnsToSecurityTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :security_tokens, :password, :string
    add_column :security_tokens, :available_uses, :integer
  end
end
