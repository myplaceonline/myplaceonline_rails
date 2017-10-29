FactoryBot.define do
  factory :admin_text_message do
    email nil
    identity nil
    send_only_to "MyString"
    exclude_numbers "MyString"
  end
end
