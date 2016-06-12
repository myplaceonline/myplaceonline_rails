class ImportUsZipCodes < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    Myp.import_zip_codes
  end
end
