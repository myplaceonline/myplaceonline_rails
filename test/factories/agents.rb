FactoryBot.define do
  factory :agent do
    agent_identity_id nil
    notes "MyText"
    visit_count 1
    archived "2017-11-20 20:58:16"
    rating 1
    is_public false
    identity nil
  end
end
