class RecreateIndex < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
