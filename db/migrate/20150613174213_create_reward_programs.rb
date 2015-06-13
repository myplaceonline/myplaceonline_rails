class CreateRewardPrograms < ActiveRecord::Migration
  def change
    create_table :reward_programs do |t|
      t.string :reward_program_name
      t.date :started
      t.date :ended
      t.string :reward_program_number
      t.string :reward_program_status
      t.text :notes
      t.references :password, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
