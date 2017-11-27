class AddColumnHardDiskPasswordToComputers < ActiveRecord::Migration[5.1]
  def change
    add_reference :computers, :hard_drive_password, foreign_key: false
    add_foreign_key :computers, :passwords, column: :hard_drive_password_id
  end
end
