class FindSubscriptionService
  def initialize(customer, subscription_id)
    @customer = customer
    @subscription_id = subscription_id
  end

  def call
    @customer.subscriptions.find(@subscription_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end