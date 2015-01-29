class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :name
      t.integer :number, limit: 8
      t.date :expires
      t.integer :security_code
      t.references :password, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
