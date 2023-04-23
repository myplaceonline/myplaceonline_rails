class ExtraZipCode < ActiveRecord::Migration[6.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      UsZipCode.create!(
        zip_code: "06824",
        city: "Fairfield",
        state: "CT",
        latitude: 41.140951698695, 
        longitude: -73.26149983817156,
        county: "Fairfield County",
      )
    end
  end
end
