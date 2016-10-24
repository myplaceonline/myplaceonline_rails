class CreateJobAccomplishments < ActiveRecord::Migration
  def change
    create_table :job_accomplishments do |t|
      t.references :job, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.string :accomplishment_title
      t.text :accomplishment
      t.datetime :accomplishment_time
      t.datetime :archived

      t.timestamps null: false
    end
  end
end
