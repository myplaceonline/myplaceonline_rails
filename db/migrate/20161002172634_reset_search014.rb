class ResetSearch014 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
