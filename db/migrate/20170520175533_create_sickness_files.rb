class CreateSicknessFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :sickness_files do |t|
      t.references :sickness, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
