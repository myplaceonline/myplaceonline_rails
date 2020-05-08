class AddColumnSavedInvitedCodeToEnteredInviteCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :entered_invite_codes, :saved_invite_code, :text
  end
end
