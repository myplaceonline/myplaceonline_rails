class CreateTherapistPhones < ActiveRecord::Migration
  def change
    create_table :therapist_phones do |t|
      t.references :owner, index: true
      t.references :therapist, index: true
      t.string :number
      t.integer :phone_type

      t.timestamps null: true
    end
  end
end
