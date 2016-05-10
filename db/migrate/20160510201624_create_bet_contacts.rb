class CreateBetContacts < ActiveRecord::Migration
  def change
    create_table :bet_contacts do |t|
      t.references :bet, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
