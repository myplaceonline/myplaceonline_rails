namespace :myp do
  desc "Myplaceonline take tasks"
  
  task :dump => :environment do
    SeedDump.dump(Category, exclude: [], file: "db/seeds.rb")
  end

  task :reload_categories => :environment do
    Myp.initialize_categories
  end
end