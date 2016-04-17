class AddColumns3ToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :personalize, :boolean
  end
end
