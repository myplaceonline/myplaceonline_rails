class AddColumnToIdentityEmails < ActiveRecord::Migration
  def change
    add_column :identity_emails, :secondary, :boolean
  end
end
