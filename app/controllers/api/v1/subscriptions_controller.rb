class Api::V1::SubscriptionsController < ApplicationController
  def create
    customer = FindCustomerService.new(params[:customer_id]).call
    return render json: { error: 'Customer not found' }, status: :not_found unless customer

    tea = Tea.find_by(id: params[:tea_id])
    return render json: { error: 'Tea not found' }, status: :not_found unless tea

    subscription = customer.subscriptions.new(subscription_params.merge(tea: tea))

    if subscription.save
      render json: { message: 'Subscription created successfully', subscription: subscription }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    customer = FindCustomerService.new(params[:customer_id]).call
    return render json: { error: 'Customer not found' }, status: :not_found unless customer

    subscriptions = customer.subscriptions
    render json: subscriptions
  end

  def update
    customer = FindCustomerService.new(params[:customer_id]).call
    return render json: { error: 'Customer not found' }, status: :not_found unless customer

    subscription = FindSubscriptionService.new(customer, params[:id]).call
    return render json: { error: 'Subscription not found' }, status: :not_found unless subscription

    if subscription.update(status: 'cancelled')
      render json: { message: 'Subscription cancelled successfully' }, status: :ok
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency)
  end
end
