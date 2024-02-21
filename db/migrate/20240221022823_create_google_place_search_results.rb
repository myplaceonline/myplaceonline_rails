class CreateGooglePlaceSearchResults < ActiveRecord::Migration[6.1]
  def change
    create_table :google_place_search_results do |t|
      t.string :search
      t.string :placeid
      t.text :jsonresult

      t.timestamps
    end
  end
end
