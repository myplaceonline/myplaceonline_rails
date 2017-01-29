class AddColumnsToPoems < ActiveRecord::Migration[5.0]
  def change
    add_column :poems, :poem_author, :string
    add_column :poems, :poem_link, :string
  end
end
