class ChangePhoneOsColumn < ActiveRecord::Migration
  def change
    change_column :phones, :operating_system_version, :string
  end
end
