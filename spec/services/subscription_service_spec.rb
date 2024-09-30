require 'rails_helper'

RSpec.describe SubscriptionService do
  let!(:customer) { create(:customer) }
  let!(:tea) { create(:tea) }
  let!(:subscription) { create(:subscription, customer: customer, tea: tea) }
  let(:valid_attributes) { { title: 'Weekly Green Tea', price: 12.0, frequency: 'weekly', status: 'active' } }

  describe '#create' do
    context 'with valid attributes' do
      it 'creates a new subscription' do
        service = SubscriptionService.new(customer, tea, valid_attributes)

        expect { service.create }.to change(Subscription, :count).by(1)
        expect(service.subscription.title).to eq('Weekly Green Tea')
        expect(service.errors).to be_empty
      end
    end

    context 'with invalid attributes' do
      it 'does not create a subscription and adds errors' do
        invalid_attributes = { title: '', price: nil, frequency: 'monthly', status: 'active' }
        service = SubscriptionService.new(customer, tea, invalid_attributes)

        expect { service.create }.to_not change(Subscription, :count)
        expect(service.errors).to include("Title can't be blank", "Price can't be blank")
      end
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      it 'updates the subscription' do
        service = SubscriptionService.new(customer, subscription)

        expect(service.update(title: 'Updated Title')).to be true
        expect(subscription.reload.title).to eq('Updated Title')
        expect(service.errors).to be_empty
      end
    end

    context 'with invalid status' do
      it 'does not update the subscription and catches ArgumentError' do
        service = SubscriptionService.new(customer, subscription)

        expect(service.update(status: 'invalid_status')).to be false
        expect(service.errors).to include("'invalid_status' is not a valid status")
      end
    end
  end

  describe '#destroy' do
    context 'when the subscription exists' do
      it 'deletes the subscription' do
        service = SubscriptionService.new(customer, subscription)

        expect { service.destroy }.to change(Subscription, :count).by(-1)
        expect(service.errors).to be_empty
      end
    end

    context 'when the subscription does not exist' do
      it 'does not delete and returns errors' do
        invalid_subscription = nil
        service = SubscriptionService.new(customer, invalid_subscription)

        expect { service.destroy }.to_not change(Subscription, :count)
        expect(service.errors).to include('Subscription not found')
      end
    end
  end
end