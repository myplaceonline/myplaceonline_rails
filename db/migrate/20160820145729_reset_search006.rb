class ResetSearch006 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
