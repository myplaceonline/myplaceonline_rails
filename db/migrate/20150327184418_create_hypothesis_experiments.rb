class CreateHypothesisExperiments < ActiveRecord::Migration
  def change
    create_table :hypothesis_experiments do |t|
      t.string :name
      t.text :notes
      t.date :started
      t.date :ended
      t.references :hypothesis, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
