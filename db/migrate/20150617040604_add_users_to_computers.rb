class AddUsersToComputers < ActiveRecord::Migration
  def change
    add_reference :computers, :administrator, index: true
    add_reference :computers, :main_user, index: true
  end
end
