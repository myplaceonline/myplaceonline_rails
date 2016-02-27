class CreateEmailGroups < ActiveRecord::Migration
  def change
    create_table :email_groups do |t|
      t.references :email, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
