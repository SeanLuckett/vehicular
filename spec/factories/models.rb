FactoryBot.define do
  factory :model do
    make
    year '2018'

    sequence :name do |n|
      Faker::Company.unique.name + n.to_s
    end

    factory :model_with_option do
      after(:create) do |model|
        model.options << create(:option)
      end
    end

    factory :model_with_options do
      after(:create) do |model|
        2.times { model.options << create(:option) }
      end
    end
  end
end
