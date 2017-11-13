class AddColumns2ToGenotypeCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :genotype_calls, :orientation, :integer
  end
end
