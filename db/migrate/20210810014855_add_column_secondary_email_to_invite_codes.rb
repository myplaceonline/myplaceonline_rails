class AddColumnSecondaryEmailToInviteCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :invite_codes, :secondary_email, :boolean
  end
end
