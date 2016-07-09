class AddColumnsToNotepads < ActiveRecord::Migration
  def change
    add_column :notepads, :archived, :datetime
  end
end
