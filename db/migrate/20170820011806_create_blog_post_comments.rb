class CreateBlogPostComments < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_post_comments do |t|
      t.references :blog_post, foreign_key: true
      t.text :comment
      t.string :commenter_name
      t.string :commenter_email
      t.string :commenter_website
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_reference :blog_post_comments, :commenter_identity, references: :identities, foreign_key: false
    add_foreign_key :blog_post_comments, :identities, column: :commenter_identity_id
  end
end
