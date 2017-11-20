class AddColumnActionToMyplets < ActiveRecord::Migration[5.1]
  def change
    add_column :myplets, :action, :string
  end
end
