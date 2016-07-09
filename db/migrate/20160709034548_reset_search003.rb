class ResetSearch003 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
