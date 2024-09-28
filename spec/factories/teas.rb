FactoryBot.define do
  factory :tea do
    title       { Faker::Tea.variety }
    description { Faker::Lorem.sentence }
    temperature { rand(70..100) }
    brew_time   { rand(3..10) }
  end
end