class CreateQuizItems < ActiveRecord::Migration[5.1]
  def change
    create_table :quiz_items do |t|
      t.references :quiz, foreign_key: true
      t.string :quiz_question
      t.text :quiz_answer
      t.string :link
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
