class AddColumnMailingListToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :mailing_list, :boolean
  end
end
