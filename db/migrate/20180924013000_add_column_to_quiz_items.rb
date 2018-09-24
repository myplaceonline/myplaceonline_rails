class AddColumnToQuizItems < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_items, :ignore, :boolean
  end
end
