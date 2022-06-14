FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
    city { Faker::Address.city }
    specialization { 'Medicine and Sugery' }
    cost_per_day { Faker::Number.number(digits: 2) }
    description { Faker::Lorem.paragraph }
  end
end
