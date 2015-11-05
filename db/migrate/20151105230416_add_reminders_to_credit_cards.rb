class AddRemindersToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :email_reminders, :boolean
  end
end
