class AddColumns15ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :non_fixed_header, :boolean
    add_column :users, :toggle_hide_footer, :boolean
  end
end
