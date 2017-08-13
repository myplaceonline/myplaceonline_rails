class CreateBlogFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_files do |t|
      t.references :blog, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
