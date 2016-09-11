class AddColumns6ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :minimize_password_checks, :boolean
  end
end
