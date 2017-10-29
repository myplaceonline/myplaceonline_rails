FactoryBot.define do
  factory :email do
    subject "MyString"
body "MyText"
copy_self false
email_category "MyString"
visit_count 1
identity nil
  end

end
