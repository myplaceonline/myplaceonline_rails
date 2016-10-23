class AddColumnsToMyreferences < ActiveRecord::Migration
  def change
    add_column :myreferences, :reference_relationship, :string
    add_column :myreferences, :years_experience, :decimal, precision: 10, scale: 2
    add_column :myreferences, :can_contact, :boolean
  end
end
