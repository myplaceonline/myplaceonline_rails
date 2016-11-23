class ResetFeedCounts < ActiveRecord::Migration
  def change
    Feed.all.each do |x|
      MyplaceonlineExecutionContext.do_identity(x.identity) do
        x.reset_counts
      end
    end
  end
end
