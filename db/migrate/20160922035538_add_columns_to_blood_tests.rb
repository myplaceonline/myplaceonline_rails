class AddColumnsToBloodTests < ActiveRecord::Migration
  def change
    add_reference :blood_tests, :doctor, index: true, foreign_key: true
    add_reference :blood_tests, :location, index: true, foreign_key: true
  end
end
