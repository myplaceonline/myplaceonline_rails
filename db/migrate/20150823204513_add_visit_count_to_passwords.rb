class AddVisitCountToPasswords < ActiveRecord::Migration
  def change
    add_column :passwords, :visit_count, :integer
  end
end
