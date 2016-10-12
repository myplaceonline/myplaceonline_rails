class AlterEducationGpaColumn < ActiveRecord::Migration
  def change
    change_column :educations, :gpa, :decimal, :precision => 9, :scale => 3
  end
end
