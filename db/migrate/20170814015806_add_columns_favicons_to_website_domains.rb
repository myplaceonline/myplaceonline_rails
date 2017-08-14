class AddColumnsFaviconsToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_reference :website_domains, :favicon_ico_identity_file, references: :identity_files, foreign_key: false
    add_foreign_key :website_domains, :identity_files, column: :favicon_ico_identity_file_id
    add_reference :website_domains, :favicon_png_identity_file, references: :identity_files, foreign_key: false
    add_foreign_key :website_domains, :identity_files, column: :favicon_png_identity_file_id
    add_reference :website_domains, :default_header_icon_identity_file, references: :identity_files, foreign_key: false
    add_foreign_key :website_domains, :identity_files, column: :default_header_icon_identity_file_id
  end
end
