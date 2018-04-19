FactoryBot.define do
  factory :make do
    name Faker::Company.unique.name
  end
end
