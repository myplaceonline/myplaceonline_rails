class RebuildIndex004 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
