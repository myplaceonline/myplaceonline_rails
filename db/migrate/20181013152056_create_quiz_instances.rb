class CreateQuizInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_instances do |t|
      t.references :quiz, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :orderby
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
