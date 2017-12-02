class AddColumnTrekToMeadows < ActiveRecord::Migration[5.1]
  def change
    add_reference :meadows, :trek, foreign_key: true
  end
end
