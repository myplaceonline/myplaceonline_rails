class AddVisitCountToIdentityFiles < ActiveRecord::Migration
  def change
    add_column :identity_files, :visit_count, :integer
  end
end
