class ResetSearch002 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
