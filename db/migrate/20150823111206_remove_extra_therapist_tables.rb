class RemoveExtraTherapistTables < ActiveRecord::Migration
  def change
    drop_table("therapist_conversations")
    drop_table("therapist_emails")
    drop_table("therapist_locations")
    drop_table("therapist_phones")
  end
end
