class CreateVolunteeringActivities < ActiveRecord::Migration
  def change
    create_table :volunteering_activities do |t|
      t.string :volunteering_activity_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
