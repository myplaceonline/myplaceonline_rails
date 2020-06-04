class AddHealthCategoryFiltertexts < ActiveRecord::Migration[5.2]
  def change
    Myp.migration_add_filtertext("allergies", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("doctor_visits", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("headaches", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("hospital_visits", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("injuries", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("medical_conditions", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("pains", "health medical problem issue condition pain")
    Myp.migration_add_filtertext("sicknesses", "health medical problem issue condition pain")
  end
end
