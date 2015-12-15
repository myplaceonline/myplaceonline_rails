class CreatePasswordSecrets < ActiveRecord::Migration
  def change
    create_table :password_secrets do |t|
      t.string :question
      t.string :answer
      t.boolean :is_encrypted_answer
      t.references :encrypted_answer, index: true
      t.references :password, index: true

      t.timestamps null: true
    end
  end
end
