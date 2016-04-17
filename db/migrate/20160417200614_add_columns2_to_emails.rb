class AddColumns2ToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :draft, :boolean
  end
end
