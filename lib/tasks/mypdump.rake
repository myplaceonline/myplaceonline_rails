# After updating this, run bin/rake myp:dump

namespace :myp do
  desc "Myplaceonline rake tasks"
  
  task :dump => :environment do
    SeedDump.dump(Category.all.order("id"), exclude: [:created_at, :updated_at], file: "db/seeds.rb")
    open("db/seeds.rb", "a") { |f|
      f.puts %{
user = User.new
user.id = User::SUPER_USER_ID
user.email = "#{ENV["ROOT_EMAIL"].blank? ? User::DEFAULT_SUPER_USER_EMAIL : ENV["ROOT_EMAIL"]}" # Generated from ENV["ROOT_EMAIL"]
user.password = "#{ENV["ROOT_PASSWORD"].blank? ? "password" : ENV["ROOT_PASSWORD"]}" # Generated from ENV["ROOT_PASSWORD"]
user.password_confirmation = user.password
user.confirmed_at = Time.now
user.user_type = User::USER_TYPE_ADMIN
user.explicit_categories = true
user.experimental_categories = true
user.save(:validate => false)

MyplaceonlineExecutionContext.do_user(user) do

  identity = Identity.create!(
    id: User::SUPER_USER_IDENTITY_ID,
    user_id: User::SUPER_USER_ID,
    name: "root",
  )
      
  user.primary_identity = identity
  user.save!
      
  Myplet.default_myplets(identity)

  if ENV["SKIP_LARGE_UNNEEDED_IMPORTS"].nil?
    Myp.import_museums
  end

  if ENV["SKIP_ZIP_CODE_IMPORTS"].nil?
    Myp.import_zip_codes
  end

  Myp.create_default_website

end

# Modifications to this file go into mypdump.rake
}
    }
  end

  task :reinitialize => :environment do
    Myp.reinitialize
  end
end
