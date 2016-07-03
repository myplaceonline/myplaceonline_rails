class AddColumnToEventPictures < ActiveRecord::Migration
  def change
    add_column :event_pictures, :position, :integer
  end
end
