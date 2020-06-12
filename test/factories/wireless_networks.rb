FactoryBot.define do
  factory :wireless_network do
    network_names { "MyString" }
    password { nil }
    location { nil }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-06-12 16:24:31" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
