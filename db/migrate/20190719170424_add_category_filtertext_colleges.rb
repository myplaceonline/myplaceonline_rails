class AddCategoryFiltertextColleges < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("educations", "collegeis high elementary schools")
  end
end
