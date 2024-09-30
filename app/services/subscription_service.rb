class SubscriptionService
  attr_reader :customer, :tea, :subscription, :errors

  def initialize(customer, tea_or_subscription, params = {})
    @customer = customer
    @tea = tea_or_subscription if tea_or_subscription.is_a?(Tea)
    @subscription = tea_or_subscription if tea_or_subscription.is_a?(Subscription)
    @params = params
    @errors = []
  end

  def create
    @subscription = customer.subscriptions.new(@params.merge(tea: tea))
    save_subscription
  end

  def update(params)
    return false unless subscription

    begin
      if subscription.update(params)
        true
      else
        @errors = subscription.errors.full_messages
        false
      end
    rescue ArgumentError => e
      @errors = [e.message]
      false
    end
  end

  def destroy
    if subscription.nil?
      @errors = ["Subscription not found"]
      return false
    end

    if subscription.destroy
      true
    else
      @errors = subscription.errors.full_messages
      false
    end
  end

  private

  def save_subscription
    if subscription.save
      true
    else
      @errors = subscription.errors.full_messages
      false
    end
  end
end