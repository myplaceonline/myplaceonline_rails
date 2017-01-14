class ResetSearch018 < ActiveRecord::Migration[5.0]
  def change
    UserIndex.reset!
  end
end
