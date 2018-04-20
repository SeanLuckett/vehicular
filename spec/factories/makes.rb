FactoryBot.define do
  factory :make do
    sequence :name do |n|
      Faker::Company.unique.name + n.to_s
    end
  end
end
