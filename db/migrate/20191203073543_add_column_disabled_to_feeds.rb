class AddColumnDisabledToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :disabled, :boolean
  end
end
