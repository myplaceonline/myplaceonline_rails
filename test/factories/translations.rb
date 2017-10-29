FactoryBot.define do
  factory :translation do
    translation_input "MyText"
    translation_output "MyText"
    input_language "MyString"
    output_language "MyString"
    source "MyString"
    website "MyString"
    notes "MyText"
    visit_count 1
    archived "2017-08-17 07:41:12"
    rating 1
    identity nil
  end
end
