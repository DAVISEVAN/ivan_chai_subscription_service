class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_customer, only: [:create, :index, :update, :show, :destroy]
  before_action :set_subscription, only: [:update, :show, :destroy]

  def create
    tea = Tea.find_by(id: params[:tea_id])
    return render json: { error: 'Tea not found' }, status: :not_found unless tea

    subscription_service = SubscriptionService.new(@customer, tea, subscription_params)
    if subscription_service.create
      render json: SubscriptionSerializer.new(subscription_service.subscription, include: [:tea]).serializable_hash.to_json, status: :created
    else
      render json: { errors: subscription_service.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: SubscriptionSerializer.new(@subscription, include: [:tea]).serializable_hash.to_json
  end

  def index
    subscriptions = @customer.subscriptions
    render json: SubscriptionSerializer.new(subscriptions, include: [:tea]).serializable_hash.to_json
  end

  def update
    subscription_service = SubscriptionService.new(@customer, @subscription)
    if subscription_service.update(subscription_params)
      render json: SubscriptionSerializer.new(@subscription, include: [:tea]).serializable_hash.to_json, status: :ok
    else
      render json: { errors: subscription_service.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    subscription_service = SubscriptionService.new(@customer, @subscription)
    if subscription_service.destroy
      render json: { message: 'Subscription deleted successfully' }, status: :ok
    else
      render json: { errors: subscription_service.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find_by(id: params[:customer_id])
    render json: { error: 'Customer not found' }, status: :not_found unless @customer
  end

  def set_subscription
    @subscription = @customer.subscriptions.find_by(id: params[:id])
    render json: { error: 'Subscription not found' }, status: :not_found unless @subscription
  end

  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency, :status)
  end
end