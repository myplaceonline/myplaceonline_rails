class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :concert_date
      t.string :concert_title
      t.references :location, index: true
      t.text :notes
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
