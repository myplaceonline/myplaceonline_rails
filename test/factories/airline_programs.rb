FactoryBot.define do
  factory :airline_program do
    program_name { "MyString" }
    password { nil }
    membership { nil }
    status { "MyString" }
    notes { "MyText" }
    visit_count { 1 }
    archived { "2020-12-29 13:53:53" }
    rating { 1 }
    is_public { false }
    identity { nil }
  end
end
