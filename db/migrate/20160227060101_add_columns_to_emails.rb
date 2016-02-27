class AddColumnsToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :use_bcc, :boolean
  end
end
