class SubscriptionSerializer
  include JSONAPI::Serializer

  attributes :title, :price, :status, :frequency, :customer_id

  belongs_to :tea

  attribute :price do |object|
    object.price.to_f
  end
end