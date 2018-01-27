class CreateComputerEnvironmentPasswords < ActiveRecord::Migration[5.1]
  def change
    create_table :computer_environment_passwords do |t|
      t.references :computer_environment, foreign_key: true
      t.references :password, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
