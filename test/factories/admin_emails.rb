FactoryBot.define do
  factory :admin_email do
    email nil
    identity nil
    send_only_to "MyString"
    exclude_emails "MyString"
  end
end
