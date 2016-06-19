class ResetSearch001 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
