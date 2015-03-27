class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
