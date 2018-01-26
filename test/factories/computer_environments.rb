FactoryBot.define do
  factory :computer_environment do
    computer_environment_name "MyString"
    computer_environment_type 1
    notes "MyText"
    visit_count 1
    archived "2018-01-26 15:12:44"
    rating 1
    is_public false
    identity nil
  end
end
