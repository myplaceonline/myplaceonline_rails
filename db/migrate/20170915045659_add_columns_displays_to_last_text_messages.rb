class AddColumnsDisplaysToLastTextMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :last_text_messages, :from_display, :string
    add_column :last_text_messages, :to_display, :string
  end
end
