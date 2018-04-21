FactoryBot.define do
  factory :model do
    make
    year '2018'

    sequence :name do |n|
      Faker::Company.unique.name + n.to_s
    end
  end
end
