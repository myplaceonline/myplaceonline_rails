class CreateWhatdidiwearthenContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :whatdidiwearthen_contacts do |t|
      t.references :whatdidiwearthen, foreign_key: true
      t.references :contact, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public
      t.text :notes

      t.timestamps
    end
  end
end
