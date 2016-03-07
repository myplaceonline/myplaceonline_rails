class AddColumnsToEmailTokens < ActiveRecord::Migration
  def change
    add_reference :email_tokens, :identity, index: true, foreign_key: true
  end
end
