class AddColumns2ToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :subject, :string
  end
end
