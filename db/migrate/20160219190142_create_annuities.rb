class CreateAnnuities < ActiveRecord::Migration
  def change
    create_table :annuities do |t|
      t.string :annuity_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
