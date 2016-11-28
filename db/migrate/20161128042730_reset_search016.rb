class ResetSearch016 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
