class Api::V1::SubscriptionsController < ApplicationController
  before_action :set_customer, only: [:create, :index, :update, :show, :destroy]
  before_action :set_subscription, only: [:update, :show, :destroy]

  def create
    tea = Tea.find_by(id: params[:tea_id])
    if tea.nil?
      render json: { error: 'Tea not found' }, status: :not_found
      return
    end

    subscription = @customer.subscriptions.new(subscription_params.merge(tea: tea))

    if subscription.save
      render json: { message: 'Subscription created successfully', subscription: subscription }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    subscription = @customer.subscriptions.find(params[:id])
    render json: subscription
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subscription not found' }, status: :not_found
  end

  def index
    subscriptions = @customer.subscriptions
    render json: subscriptions
  end

  def update
    begin
      if @subscription.update(subscription_params)
        render json: { message: 'Subscription cancelled successfully' }, status: :ok
      else
        render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ArgumentError => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end
  end

  def destroy
    if @subscription.destroy
      render json: { message: 'Subscription deleted successfully' }, status: :ok
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:customer_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Customer not found' }, status: :not_found
  end

  def set_subscription
    @subscription = @customer.subscriptions.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subscription not found' }, status: :not_found
  end

  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency, :status)
  end
end