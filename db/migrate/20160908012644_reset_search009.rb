class ResetSearch009 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
