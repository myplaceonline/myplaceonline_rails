class ResetSearch005 < ActiveRecord::Migration
  def change
    UserIndex.reset!
  end
end
