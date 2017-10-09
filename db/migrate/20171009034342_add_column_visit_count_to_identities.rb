class AddColumnVisitCountToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :visit_count, :integer
  end
end
