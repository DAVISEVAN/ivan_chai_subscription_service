# Creating some sample Teas
tea1 = Tea.create!(
  title: 'Green Tea',
  description: 'A refreshing and healthy green tea.',
  temperature: 80,
  brew_time: 3
)

tea2 = Tea.create!(
  title: 'Black Tea',
  description: 'A bold and strong black tea.',
  temperature: 95,
  brew_time: 5
)

# Creating a sample Customer
customer = Customer.create!(
  first_name: 'John',
  last_name: 'Doe',
  email: 'john.doe@example.com',
  address: '123 Tea Street, Flavor Town'
)

# Creating sample Subscriptions
Subscription.create!(
  title: 'Monthly Green Tea Subscription',
  price: 15.0,
  status: 'active',
  frequency: 'monthly',
  customer: customer,
  tea: tea1
)

Subscription.create!(
  title: 'Weekly Black Tea Subscription',
  price: 7.5,
  status: 'cancelled',
  frequency: 'weekly',
  customer: customer,
  tea: tea2
)