class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.datetime :status_time
      t.text :three_good_things
      t.references :owner, index: true

      t.timestamps
    end
  end
end
