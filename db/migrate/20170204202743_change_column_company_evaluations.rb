class ChangeColumnCompanyEvaluations < ActiveRecord::Migration[5.0]
  def change
    change_column :company_interactions, :company_interaction_date, :datetime
  end
end
