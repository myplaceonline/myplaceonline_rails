namespace :myp do
  desc "Myplaceonline rake tasks"
  
  task :dump => :environment do
    SeedDump.dump(Category, exclude: [:created_at, :updated_at], file: "db/seeds.rb")
    open("db/seeds.rb", "a") { |f|
      f.puts %{
user = User.new
user.id = 0
user.email = "#{ENV["ROOT_EMAIL"].blank? ? Myplaceonline::DEFAULT_ROOT_EMAIL : ENV["ROOT_EMAIL"]}"
user.password = "#{ENV["ROOT_PASSWORD"].blank? ? "password" : ENV["ROOT_PASSWORD"]}"
user.password_confirmation = user.password
user.confirmed_at = Time.now
user.user_type = 1
user.save(:validate => false)

User.current_user = user
  
identity = Identity.new
identity.id = 0
identity.user = user
identity.save!
    
user.primary_identity = identity
user.save!
    
Myplet.default_myplets(identity)

if ENV["SKIP_LARGE_IMPORTS"].nil?
  Myp.import_museums
end

# Modifications to this file go into mypdump.rake
}
    }
  end

  task :reload_categories => :environment do
    Myp.initialize_categories
  end
end