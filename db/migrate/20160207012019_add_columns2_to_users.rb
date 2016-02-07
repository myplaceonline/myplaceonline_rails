class AddColumns2ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :items_per_page, :integer
  end
end
