class AddColumnAccusedStoryToReputationReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reputation_reports, :accused_story, :text
  end
end
