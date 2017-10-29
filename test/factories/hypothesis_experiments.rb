FactoryBot.define do
  factory :hypothesis_experiment, :class => 'HypothesisExperiments' do
    name "MyString"
notes "MyText"
started "2015-03-27"
ended "2015-03-27"
hypothesis nil
identity nil
  end

end
