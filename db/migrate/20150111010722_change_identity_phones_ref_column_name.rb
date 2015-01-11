class ChangeIdentityPhonesRefColumnName < ActiveRecord::Migration
  def change
    rename_column :identity_phones, :identity_id, :ref_id
  end
end
