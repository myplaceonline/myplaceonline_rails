class AddColumnsToEmailUnsubscriptions < ActiveRecord::Migration
  def change
    add_reference :email_unsubscriptions, :identity, index: true, foreign_key: true
  end
end
