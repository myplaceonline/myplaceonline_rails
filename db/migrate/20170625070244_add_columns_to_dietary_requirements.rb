class AddColumnsToDietaryRequirements < ActiveRecord::Migration[5.1]
  def change
    add_column :dietary_requirements, :dietary_requirement_amount, :decimal, precision: 10, scale: 2
    add_column :dietary_requirements, :dietary_requirement_type, :integer
    add_column :dietary_requirements, :dietary_requirement_context, :integer
  end
end
