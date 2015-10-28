class AddNotesToPassports < ActiveRecord::Migration
  def change
    add_column :passports, :notes, :text
  end
end
