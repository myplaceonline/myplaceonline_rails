class CreateAccomplishments < ActiveRecord::Migration
  def change
    create_table :accomplishments do |t|
      t.string :name
      t.text :accomplishment
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
