class AddColumns2ToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :graduated, :datetime
    add_column :educations, :student_id, :string
  end
end
