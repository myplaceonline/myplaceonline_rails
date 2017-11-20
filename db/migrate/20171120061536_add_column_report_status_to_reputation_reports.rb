class AddColumnReportStatusToReputationReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reputation_reports, :report_status, :integer
  end
end
