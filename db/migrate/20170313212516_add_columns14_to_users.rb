class AddColumns14ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :encryption_mode, :integer
  end
end
