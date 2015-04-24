class AddColumnToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :additional_filtertext, :string
  end
end
