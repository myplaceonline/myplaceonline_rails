class ResetSearch013 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
