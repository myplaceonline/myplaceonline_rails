class AddColumnsToDueItems < ActiveRecord::Migration
  def change
    add_reference :due_items, :myplaceonline_due_display, index: true
    add_reference :complete_due_items, :myplaceonline_due_display, index: true
    add_reference :snoozed_due_items, :myplaceonline_due_display, index: true
  end
end
