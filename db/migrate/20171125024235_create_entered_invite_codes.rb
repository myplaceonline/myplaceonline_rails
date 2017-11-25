class CreateEnteredInviteCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :entered_invite_codes do |t|
      t.references :user, foreign_key: true
      t.references :website_domain, foreign_key: true

      t.timestamps
    end
  end
end
