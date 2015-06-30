class AddPhoneTypeToIdentityPhones < ActiveRecord::Migration
  def change
    add_column :identity_phones, :phone_type, :integer
  end
end
