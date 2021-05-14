class AddColumnDisableSignupExtrasToInviteCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :invite_codes, :disable_signup_extras, :boolean
  end
end
