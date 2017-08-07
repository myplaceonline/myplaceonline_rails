class AddColumnsToTextMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :text_messages, :long_body, :text
  end
end
