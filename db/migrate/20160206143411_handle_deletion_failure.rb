class HandleDeletionFailure < ActiveRecord::Migration
  def change
    p = Promotion.find(16)
    CalendarItem.destroy_calendar_items(p.identity, p.class, model_id: p.id)
  end
end
