class CreateEmailUnsubscriptions < ActiveRecord::Migration
  def change
    create_table :email_unsubscriptions do |t|
      t.string :email
      t.string :category

      t.timestamps null: false
    end
  end
end
