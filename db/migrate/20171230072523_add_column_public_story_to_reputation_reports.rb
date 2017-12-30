class AddColumnPublicStoryToReputationReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reputation_reports, :public_story, :text
  end
end
