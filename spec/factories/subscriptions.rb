FactoryBot.define do
  factory :subscription do
    title     { "Monthly Subscription" }
    price     { Faker::Commerce.price(range: 5.0..20.0) }
    status    { :active }
    frequency { %w[weekly monthly yearly].sample }
    association :customer
    association :tea
  end
end