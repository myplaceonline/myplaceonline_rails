class CreateSunExposures < ActiveRecord::Migration
  def change
    create_table :sun_exposures do |t|
      t.datetime :exposure_start
      t.datetime :exposure_end
      t.string :uncovered_body_parts
      t.string :sunscreened_body_parts
      t.string :sunscreen_type
      t.references :identity, index: true

      t.timestamps
    end
  end
end
