class AddColumnsToJobs2 < ActiveRecord::Migration
  def change
    add_column :jobs, :business_unit, :string
    add_column :jobs, :email, :string
    add_column :jobs, :internal_mail_id, :string
    add_column :jobs, :internal_mail_server, :string
    add_reference :jobs, :internal_address, index: true
    add_column :jobs, :department_identifier, :string
    add_column :jobs, :division_identifier, :string
    add_column :jobs, :personnel_code, :string
  end
end
