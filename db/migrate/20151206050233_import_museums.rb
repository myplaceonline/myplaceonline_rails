class ImportMuseums < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    Myp.import_museums
  end
end
