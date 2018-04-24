FactoryBot.define do
  factory :vehicle do
    model
    owner 'Some Name'

    factory :vehicle_with_option do
      after(:create) do |model|
        model.options << create(:option)
      end
    end
  end
end
