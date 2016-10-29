class ResetSearch015 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
