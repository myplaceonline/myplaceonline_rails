class AddColumnNotesToSshKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :ssh_keys, :notes, :text
  end
end
