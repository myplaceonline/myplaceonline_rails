class CreateHobbies < ActiveRecord::Migration
  def change
    create_table :hobbies do |t|
      t.string :hobby_name
      t.text :notes
      t.references :owner, index: true

      t.timestamps
    end
  end
end
