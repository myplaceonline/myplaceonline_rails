class ResetSearch004 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
