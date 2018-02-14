class AddColumnToComputerEnvironmentAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :computer_environment_addresses, :is_public, :boolean
  end
end
