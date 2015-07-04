class AddPageTransitionToUser < ActiveRecord::Migration
  def change
    add_column :users, :page_transition, :integer
  end
end
