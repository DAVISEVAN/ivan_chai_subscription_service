class FindCustomerService
  def initialize(customer_id)
    @customer_id = customer_id
  end

  def call
    Customer.find(@customer_id)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end