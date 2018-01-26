class CreateComputerEnvironments < ActiveRecord::Migration[5.1]
  def change
    create_table :computer_environments do |t|
      t.string :computer_environment_name
      t.integer :computer_environment_type
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
