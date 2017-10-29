FactoryBot.define do
  factory :permission_share do
    subject_class "MyString"
subject_id 1
subject "MyString"
body "MyText"
email false
copy_self false
share nil
identity nil
  end

end
