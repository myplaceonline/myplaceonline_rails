class AddTitleToDiaryEntries < ActiveRecord::Migration
  def change
    add_column :diary_entries, :diary_title, :string
  end
end
