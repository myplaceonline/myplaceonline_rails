class ResetSearch007 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
