class CreateComputerEnvironmentAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :computer_environment_addresses do |t|
      t.references :computer_environment, foreign_key: true
      t.string :host_name
      t.string :ip_address
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
