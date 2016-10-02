class CreateJobFiles < ActiveRecord::Migration
  def change
    create_table :job_files do |t|
      t.references :job, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
