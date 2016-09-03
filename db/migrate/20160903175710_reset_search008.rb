class ResetSearch008 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
