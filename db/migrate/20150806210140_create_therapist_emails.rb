class CreateTherapistEmails < ActiveRecord::Migration
  def change
    create_table :therapist_emails do |t|
      t.references :therapist, index: true
      t.references :owner, index: true
      t.string :email

      t.timestamps null: true
    end
  end
end
