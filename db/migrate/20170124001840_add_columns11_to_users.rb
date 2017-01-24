class AddColumns11ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :after_new_item, :integer
  end
end
