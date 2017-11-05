class AddColumnInternalToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :internal, :boolean
  end
end
