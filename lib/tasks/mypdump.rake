namespace :myp do
  desc "Dump basic seeds.rb"
  task :dump => :environment do
    SeedDump.dump(Category, exclude: [], file: "db/seeds.rb")
  end
end