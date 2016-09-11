class AddColumns2ToConnections < ActiveRecord::Migration
  def change
    add_reference :connections, :contact, index: true, foreign_key: true
  end
end
