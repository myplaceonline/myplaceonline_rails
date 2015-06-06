class CreateJobSalaries < ActiveRecord::Migration
  def change
    create_table :job_salaries do |t|
      t.references :identity, index: true
      t.references :job, index: true
      t.date :started
      t.date :ended
      t.text :notes
      t.decimal :salary, precision: 10, scale: 2
      t.integer :salary_period

      t.timestamps
    end
  end
end
