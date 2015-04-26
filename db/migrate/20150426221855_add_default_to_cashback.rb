class AddDefaultToCashback < ActiveRecord::Migration
  def change
    add_column :cashbacks, :default_cashback, :boolean
  end
end
