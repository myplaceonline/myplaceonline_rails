class HandleDeletionFailure < ActiveRecord::Migration
  def change
    CalendarItem.destroy_calendar_items(Identity.find(1), "Promotion", model_id: 16)
  end
end
