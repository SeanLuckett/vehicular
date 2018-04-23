FactoryBot.define do
  factory :option do
    sequence :name do |n|
      Faker::Company.unique.name + n.to_s
    end
  end
end
