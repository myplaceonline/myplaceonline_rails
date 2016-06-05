class RebuildIndex001 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
