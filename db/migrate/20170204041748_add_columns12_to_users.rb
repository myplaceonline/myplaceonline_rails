class AddColumns12ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :allow_adding_existing_file, :boolean
  end
end
