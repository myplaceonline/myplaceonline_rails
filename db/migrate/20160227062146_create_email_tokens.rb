class CreateEmailTokens < ActiveRecord::Migration
  def change
    create_table :email_tokens do |t|
      t.string :email
      t.string :token

      t.timestamps null: false
    end
  end
end
