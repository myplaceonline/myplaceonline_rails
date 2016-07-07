FactoryGirl.define do
  factory :password_secret_share do
    password_secret nil
    identity nil
    unecrypted_answer "MyString"
  end
end
