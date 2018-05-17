FactoryBot.define do
  factory :wallet_transaction_file do
    wallet_transaction nil
    identity_file nil
    identity nil
    position 1
    is_public false
  end
end
