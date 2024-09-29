require 'rails_helper'

RSpec.describe 'Subscriptions API', type: :request do
  let!(:customer) { create(:customer) }
  let!(:tea) { create(:tea) }
  let!(:subscription) { create(:subscription, customer: customer, tea: tea) }

  describe 'GET /api/v1/customers/:customer_id/subscriptions/:id' do
    context 'when the subscription exists' do
      it 'returns the subscription details' do
        get "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}"
        expect(response).to have_http_status(:ok)

        subscription_data = JSON.parse(response.body)
        expect(subscription_data['id']).to eq(subscription.id)
        expect(subscription_data['title']).to eq(subscription.title)
        expect(subscription_data['price'].to_f).to eq(subscription.price)
        expect(subscription_data['status']).to eq(subscription.status)
      end
    end

    context 'when the subscription does not exist' do
      it 'returns a 404 not found error' do
        get "/api/v1/customers/#{customer.id}/subscriptions/9999"
        expect(response).to have_http_status(:not_found)

        error_message = JSON.parse(response.body)
        expect(error_message['error']).to eq('Subscription not found')
      end
    end
  end

  describe 'POST /api/v1/customers/:customer_id/subscriptions' do
    context 'with valid attributes' do
      it 'creates a new subscription' do
        post "/api/v1/customers/#{customer.id}/subscriptions", params: { tea_id: tea.id, subscription: { title: 'Monthly Tea', price: 10.0, frequency: 'monthly' } }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Subscription created successfully')
      end
    end

    context 'when customer does not exist' do
      it 'returns a not found error' do
        post "/api/v1/customers/-1/subscriptions", params: { tea_id: tea.id, subscription: { title: 'Monthly Tea', price: 10.0, frequency: 'monthly' } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Customer not found')
      end
    end

    context 'when tea does not exist' do
      it 'returns a not found error' do
        post "/api/v1/customers/#{customer.id}/subscriptions", params: { tea_id: -1, subscription: { title: 'Monthly Tea', price: 10.0, frequency: 'monthly' } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Tea not found')
      end
    end

    context 'with invalid subscription attributes' do
      it 'returns an unprocessable entity error' do
        post "/api/v1/customers/#{customer.id}/subscriptions", params: { tea_id: tea.id, subscription: { title: '', price: nil, frequency: 'monthly' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank", "Price can't be blank")
      end
    end
  end

  describe 'GET /api/v1/customers/:customer_id/subscriptions' do
    context 'when customer exists' do
      it 'returns all subscriptions for the customer' do
        get "/api/v1/customers/#{customer.id}/subscriptions"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context 'when customer does not exist' do
      it 'returns a not found error' do
        get "/api/v1/customers/-1/subscriptions"
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Customer not found')
      end
    end
  end

  describe 'PATCH /api/v1/customers/:customer_id/subscriptions/:id' do
    context 'when subscription is cancelled successfully' do
      it 'updates the subscription status to cancelled' do
        patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}", params: { subscription: { status: 'cancelled' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Subscription cancelled successfully')
        expect(subscription.reload.status).to eq('cancelled')
      end
    end

    context 'when subscription does not exist' do
      it 'returns a not found error' do
        patch "/api/v1/customers/#{customer.id}/subscriptions/-1"
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Subscription not found')
      end
    end

    context 'when update fails' do
      it 'returns an unprocessable entity error' do
        patch "/api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}", params: { subscription: { status: 'invalid_status' } }
        expect(response).to have_http_status(:unprocessable_entity)
        errors = JSON.parse(response.body)['errors']
        expect(errors).to include("'invalid_status' is not a valid status")
      end
    end
  end
end