# Clear existing data
Customer.destroy_all
Tea.destroy_all
Subscription.destroy_all

# Create customers
customer1 = Customer.create!(first_name: 'John', last_name: 'Doe', email: 'john@example.com', address: '123 Tea St.')
customer2 = Customer.create!(first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com', address: '456 Coffee Rd.')

# Create teas
tea1 = Tea.create!(title: 'Green Tea', description: 'A refreshing and healthy green tea.', temperature: 80, brew_time: 3)
tea2 = Tea.create!(title: 'Black Tea', description: 'A strong and bold black tea.', temperature: 95, brew_time: 4)
tea3 = Tea.create!(title: 'Oolong Tea', description: 'A fragrant and fruity oolong tea.', temperature: 85, brew_time: 5)

# Create subscriptions (active and cancelled)
Subscription.create!(title: 'Monthly Green Tea Subscription', price: 15.0, frequency: 'monthly', status: 'active', customer: customer1, tea: tea1)
Subscription.create!(title: 'Weekly Black Tea Subscription', price: 10.0, frequency: 'weekly', status: 'cancelled', customer: customer1, tea: tea2)
