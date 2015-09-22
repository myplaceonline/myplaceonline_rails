class CreateConcertMusicalGroups < ActiveRecord::Migration
  def change
    create_table :concert_musical_groups do |t|
      t.references :owner, index: true
      t.references :concert, index: true
      t.references :musical_group, index: true

      t.timestamps
    end
  end
end
