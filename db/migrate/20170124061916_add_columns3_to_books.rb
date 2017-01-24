class AddColumns3ToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :when_discarded, :datetime
  end
end
