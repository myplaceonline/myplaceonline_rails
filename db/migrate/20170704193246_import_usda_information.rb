class ImportUsdaInformation < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    Rake::Task["usda:import"].invoke
  end
end
