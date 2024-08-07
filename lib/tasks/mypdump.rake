# After updating this, run bin/rake myp:dump

namespace :myp do
  desc "Myplaceonline rake tasks"
  
  task :dump => :environment do
    SeedDump.dump(Category.all.order("id"), exclude: [:created_at, :updated_at], file: "db/seeds.rb")
    open("db/seeds.rb", "a") { |f|
      f.puts %{
# Reinitialize to cache the categories created above
Myp.reinitialize

Rails.logger.info{"Loading seeds started"}

user = User.new
user.id = User::SUPER_USER_ID
user.email = "#{ENV["ROOT_EMAIL"].blank? ? User::DEFAULT_SUPER_USER_EMAIL : ENV["ROOT_EMAIL"]}" # Generated from ENV["ROOT_EMAIL"]
user.password = "#{ENV["ROOT_PASSWORD"].blank? ? "password" : ENV["ROOT_PASSWORD"]}" # Generated from ENV["ROOT_PASSWORD"]
user.password_confirmation = user.password
user.confirmed_at = Time.now
user.user_type = User::USER_TYPE_ADMIN
user.explicit_categories = true
user.experimental_categories = true
user.save(validate: false)

MyplaceonlineExecutionContext.do_user(user) do

  identity = Identity.new
  identity.id = User::SUPER_USER_IDENTITY_ID
  identity.user_id = User::SUPER_USER_ID
  identity.name = "root"
  identity.website_domain_default = true
  identity.save(validate: false)

  # We just need a temporary object that points to the identity we just created
  MyplaceonlineExecutionContext.do_permission_target(Identity.new(identity: identity)) do
    if ENV["SKIP_LARGE_UNNEEDED_IMPORTS"].nil?
      Myp.import_museums
    end

    if ENV["SKIP_ZIP_CODE_IMPORTS"].nil?
      Myp.import_zip_codes
    end

    website_domain = Myp.create_default_website

    identity.update_column(:website_domain_id, website_domain.id)

    MyplaceonlineExecutionContext.do_identity(identity) do
      Rails.logger.info{"Seeded website domain. Reinitializing..."}

      # Reload the statically cached default domain
      Myp.reinitialize_in_rails_context

      # Reload the superuser's identities
      user.reload

      identity.after_create
    end

  end

end

Rails.logger.info{"Loading seeds completed"}

# Modifications to this file go into mypdump.rake
}
    }
  end

  task :reinitialize => :environment do
    Rails.logger.info{"mypdump.rake reinitialize"}
    Myp.reinitialize
  end
end
