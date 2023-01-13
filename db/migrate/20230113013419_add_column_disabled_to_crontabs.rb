class AddColumnDisabledToCrontabs < ActiveRecord::Migration[6.1]
  def change
    add_column :crontabs, :disabled, :boolean
  end
end
