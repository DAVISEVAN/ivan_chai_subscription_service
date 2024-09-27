require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:customer) { create(:customer) }
  let(:tea) { create(:tea) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new subscription' do
        post :create, params: { customer_id: customer.id, tea_id: tea.id, subscription: { title: 'Monthly Tea', price: 10.0, frequency: 'monthly' } }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Subscription created successfully')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new subscription' do
        post :create, params: { customer_id: customer.id, tea_id: tea.id, subscription: { title: '', price: '', frequency: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:subscription) { create(:subscription, customer: customer, tea: tea) }

    it 'cancels the subscription' do
      patch :update, params: { customer_id: customer.id, id: subscription.id }
      expect(response).to have_http_status(:ok)
      expect(subscription.reload.status).to eq('cancelled')
    end
  end

  describe 'GET #index' do
    it 'returns all subscriptions for the customer' do
      create_list(:subscription, 3, customer: customer, tea: tea)
      get :index, params: { customer_id: customer.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end