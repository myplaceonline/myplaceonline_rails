class ResetSearch012 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
