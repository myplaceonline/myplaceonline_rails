FactoryGirl.define do
  factory :ssh_key do
    ssh_key_name "MyString"
ssh_private_key "MyText"
ssh_public_key "MyText"
password nil
visit_count 1
identity nil
  end

end
