class AddColumnSecretiveToBars < ActiveRecord::Migration[5.1]
  def change
    add_column :bars, :secretive, :boolean
  end
end
