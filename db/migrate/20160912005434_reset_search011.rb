class ResetSearch011 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
