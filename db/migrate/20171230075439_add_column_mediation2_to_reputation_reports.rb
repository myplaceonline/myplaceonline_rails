class AddColumnMediation2ToReputationReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reputation_reports, :mediation, :text
  end
end
