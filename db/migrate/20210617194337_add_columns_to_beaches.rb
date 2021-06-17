class AddColumnsToBeaches < ActiveRecord::Migration[6.1]
  def change
    add_column :beaches, :fires_allowed, :boolean
    add_column :beaches, :fires_disallowed, :boolean
    add_column :beaches, :free, :boolean
    add_column :beaches, :paid, :boolean
    add_column :beaches, :tents_allowed, :boolean
    add_column :beaches, :tents_disallowed, :boolean
    add_column :beaches, :canopies_allowed, :boolean
    add_column :beaches, :canopies_disallowed, :boolean
  end
end
