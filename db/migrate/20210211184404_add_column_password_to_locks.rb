class AddColumnPasswordToLocks < ActiveRecord::Migration[5.2]
  def change
    add_reference :locks, :password, foreign_key: true
  end
end
