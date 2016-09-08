class ResetSearch010 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
