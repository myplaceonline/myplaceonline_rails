class CreateHypotheses < ActiveRecord::Migration
  def change
    create_table :hypotheses do |t|
      t.string :name
      t.text :notes
      t.references :question, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
