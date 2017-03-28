class RenameLicensesToSoftwareLicenses < ActiveRecord::Migration[5.0]
  def change
    rename_table :licenses, :software_licenses
    cat = Category.where(name: "licenses").take!
    cat.name = "software_licenses"
    cat.link = "software_licenses"
    cat.additional_filtertext = ""
    cat.save!
  end
end
