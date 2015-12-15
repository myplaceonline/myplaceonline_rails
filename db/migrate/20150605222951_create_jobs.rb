class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.references :company, index: true
      t.date :started
      t.date :ended
      t.references :manager_contact, index: true
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
