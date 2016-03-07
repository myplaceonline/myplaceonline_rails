class CreateComputerSshKeys < ActiveRecord::Migration
  def change
    create_table :computer_ssh_keys do |t|
      t.references :computer, index: true, foreign_key: true
      t.references :ssh_key, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
