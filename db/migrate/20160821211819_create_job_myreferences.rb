class CreateJobMyreferences < ActiveRecord::Migration
  def change
    create_table :job_myreferences do |t|
      t.references :job, index: true, foreign_key: true
      t.references :myreference, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
