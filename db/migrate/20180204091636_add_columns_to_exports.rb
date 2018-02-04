class AddColumnsToExports < ActiveRecord::Migration[5.1]
  def change
    add_reference :exports, :security_token, foreign_key: true
  end
end
