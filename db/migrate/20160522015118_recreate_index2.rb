class RecreateIndex2 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
