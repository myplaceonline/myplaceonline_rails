class AddColumnSkipSuggestionsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :skip_suggestions, :boolean
    add_column :users, :last_suggestions, :datetime
  end
end
