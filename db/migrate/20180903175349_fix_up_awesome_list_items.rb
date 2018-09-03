class FixUpAwesomeListItems < ActiveRecord::Migration[5.1]
  def change
    add_column :awesome_list_items, :is_public, :boolean
  end
end
