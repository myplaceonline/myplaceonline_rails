class AddClipboardOptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clipboard_transform_numbers, :boolean
  end
end
