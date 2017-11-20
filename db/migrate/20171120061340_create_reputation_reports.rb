class CreateReputationReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reputation_reports do |t|
      t.string :short_description
      t.text :story
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
