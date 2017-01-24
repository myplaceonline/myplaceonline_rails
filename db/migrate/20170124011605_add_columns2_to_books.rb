class AddColumns2ToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :when_owned, :datetime
  end
end
