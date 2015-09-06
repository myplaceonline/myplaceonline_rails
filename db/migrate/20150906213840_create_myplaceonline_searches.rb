class CreateMyplaceonlineSearches < ActiveRecord::Migration
  def change
    create_table :myplaceonline_searches do |t|
      t.references :owner, index: true
      t.boolean :trash

      t.timestamps
    end
  end
end
