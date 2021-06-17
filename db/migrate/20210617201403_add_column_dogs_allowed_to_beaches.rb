class AddColumnDogsAllowedToBeaches < ActiveRecord::Migration[6.1]
  def change
    add_column :beaches, :dogs_allowed, :boolean
  end
end
