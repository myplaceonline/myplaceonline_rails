class RenameMddToCalendars < ActiveRecord::Migration
  def change
    rename_table :myplaceonline_due_displays, :calendars
    rename_column :complete_due_items, :myplaceonline_due_display_id, :calendar_id
    rename_column :due_items, :myplaceonline_due_display_id, :calendar_id
    rename_column :snoozed_due_items, :myplaceonline_due_display_id, :calendar_id
    Myplet.all.each do |myplet|
      User.current_user = myplet.identity.user
      myplet.title = myplet.title.gsub("myplaceonline_due_display", "calendar")
      myplet.category_name = myplet.category_name.gsub("myplaceonline_due_display", "calendar")
      myplet.save!
    end
  end
end
