class AddColumnMediationToReputationReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reputation_reports, :allow_mediation, :boolean
  end
end
