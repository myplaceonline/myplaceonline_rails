class CreateCategoryPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :category_permissions do |t|
      t.integer :action
      t.string :subject_class
      t.references :user, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
