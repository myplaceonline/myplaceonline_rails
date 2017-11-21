class AddColumnAgentToReputationReports < ActiveRecord::Migration[5.1]
  def change
    add_reference :reputation_reports, :agent, foreign_key: true
  end
end
