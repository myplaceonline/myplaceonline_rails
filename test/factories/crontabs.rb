FactoryBot.define do
  factory :crontab do
    crontab_name { "MyString" }
    dblocker { 1 }
    run_class { "MyString" }
    run_method { "MyString" }
    minutes { "MyString" }
    last_success { "2019-11-06 19:49:25" }
    run_data { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2019-11-06 19:49:25" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
