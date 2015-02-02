class ChangeCompanyColumns < ActiveRecord::Migration
  def change
    remove_column :companies, :password_id
  end
end
