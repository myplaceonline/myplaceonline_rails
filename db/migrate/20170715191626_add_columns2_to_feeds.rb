class AddColumns2ToFeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :new_notify, :boolean
  end
end
