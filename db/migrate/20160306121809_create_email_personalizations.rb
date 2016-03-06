class CreateEmailPersonalizations < ActiveRecord::Migration
  def change
    create_table :email_personalizations do |t|
      t.string :target
      t.text :additional_text
      t.boolean :do_send
      t.references :identity, index: true, foreign_key: true
      t.references :email, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
