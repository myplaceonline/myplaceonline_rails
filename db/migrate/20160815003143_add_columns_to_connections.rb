class AddColumnsToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :connection_request_token, :string
  end
end
