FactoryGirl.define do
  factory :email_personalization do
    email "MyString"
additional_text "MyText"
skip_send false
identity nil
  end

end
